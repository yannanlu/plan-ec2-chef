property :target_dir, String, required: true, name_property: true
property :file_list, Array, default: []

action :create do
  ## removes files not listed for webapp and updates the number of removed files
  n = 0
  if target_dir != nil
    Dir.entries(target_dir).grep(/\.jar$/).each do |f|
      unless new_resource.file_list.include?(f)
        File.unlink(File.join(target_dir, f))
        n = n + 1
      end
    end
    Chef::Log.info "check_jars: #{n} files removed from #{target_dir}"
  end

  if n > 0
    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end
