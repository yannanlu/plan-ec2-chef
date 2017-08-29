property :target_dir, String, required: true, name_property: true
property :source_dir, String, required: true
property :file_list, Array, default: []

action :create do
  ## copies files for webapp and updates the number of copied files
  n = 0
  if source_dir == nil or target_dir == nil
    Chef::Log.warn "copy_files: source_dir or target_dir not defined"
  else
    require 'fileutils'
    newresource.file_list.each do |f|
      s = File.join(source_dir, f)
      d = File.join(target_dir, f)
      if File.exists?(s) and File.exists?(d)
        unless FileUtils.cmp(s, d)
          FileUtils.copy_file s, d, preserve=true
          n = n + 1
        end
      elsif File.exists?(s)
        FileUtils.copy_file s, d, preserve=true
        n = n + 1
      else
        Chef::Log.warn "copy_files: #{f} not in #{source_dir}"
      end
    end
    Chef::Log.info "copy_files: #{n} files copied to #{target_dir}"
  end

  if n > 0
    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end
