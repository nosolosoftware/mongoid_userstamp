class ConfigurationNotFoundError < StandardError

  attr_reader :config

  def initialize(config)
    @config = config
    super message
  end

  def message
    <<-eos
      Mongoid Userstamp Configuration for #{config} is not defined.
      Please define the configuration using:
          Mongoid::Userstamp.config(:#{config}) do |c|
            ...
            Your configuration comes here
            ...
          end
    eos
  end

end
