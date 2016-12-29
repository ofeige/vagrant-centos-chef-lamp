
if defined?(ChefSpec)
  ChefSpec.define_matcher :zypper_repo

  def add_zypper_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:zypper_repo, :add, resource_name)
  end

  def remove_zypper_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:zypper_repo, :remove, resource_name)
  end
end
