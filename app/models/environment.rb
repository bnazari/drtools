class Environment < ActiveRecord::Base
  include SerializedColumns
  has_many :territories

  serialized_accessor :config, :enable_dsars, :boolean
  serialized_accessor :config, :enable_sitreps, :boolean
  serialized_accessor :config, :enable_dashboard, :boolean
  serialized_accessor :config, :enable_cop, :boolean
  serialized_accessor :config, :enable_iap, :boolean
  serialized_accessor :config, :time_zone_raw, :string

  def time_zone
    @tz ||= ActiveSupport::TimeZone[time_zone_raw]
  end

  def to_param
    slug
  end

  include Iap::EnvironmentAdditions
end
