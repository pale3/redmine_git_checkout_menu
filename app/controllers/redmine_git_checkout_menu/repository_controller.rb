module RedmineGitCheckoutMenu
  class RepositoryController < ApplicationController
    before_action :find_project

    def download
      Rails.logger.info "RepositoryDownloadsController: Download action triggered"
      repository = @project.repository
      if repository && repository.url.present?
        repo_path = params[:repo_path]
        repo_name = File.basename(repo_path)
        repo_full_path = File.join('/var', repo_path)
        branch = params[:branch] || 'HEAD'
        archive_name = "#{File.basename(repo_path)}-#{branch}.zip"
        archive_path = Rails.root.join('tmp', archive_name).to_s

        Rails.logger.info "PATH command: #{archive_path}"
        # Use git to create an archive of the specified branch
        command = "git --git-dir=#{repo_full_path} archive --format=zip --output=#{archive_path.shellescape} #{branch.shellescape}"
        Rails.logger.info "Executing command: #{command}"
        Rails.logger.info "DATAAAA: #{repository.inspect}"

        if system(command)
          Rails.logger.info "Archive command executed successfully"
        else
          Rails.logger.error "Archive command failed with status #{$?.exitstatus}"
          render plain: 'Failed to create archive', status: :internal_server_error
          return
        end

        if File.exist?(archive_path)
          file_size = File.size(archive_path)
          Rails.logger.info "Archive file exists at #{archive_path}, size: #{file_size} bytes"

          # Log the first few bytes for debugging
          File.open(archive_path, 'rb') do |file|
            first_bytes = file.read(20)
            Rails.logger.info "First 20 bytes of the file: #{first_bytes.inspect}"
          end

          # Ensure proper permissions
          FileUtils.chmod(0o644, archive_path)
          FileUtils.chown('redmine', 'redmine', archive_path)

          # Serve the file and delay cleanup
          begin
            send_file archive_path, type: 'application/zip', filename: archive_name, disposition: 'attachment', stream: true, buffer_size: 4096
          ensure
            Thread.new { sleep(10); FileUtils.rm(archive_path) if File.exist?(archive_path) }
          end
        else
          Rails.logger.error "Failed to create archive at #{archive_path}"
          render plain: 'Failed to create archive', status: :internal_server_error
        end
      else
        render plain: 'Repository not available for download', status: :not_found
      end
    end

    def find_project
      @project = Project.find(params[:id])
    end
  end
end

