ActiveAdmin.register Environment do
  permit_params do
    params = [:enabled, :active_start_date, :active_end_date, :slug, :short_name, :name]
    params += [:cas_incident_number, :dsars_incident_number, :dr_number, :arcdata_incident_id]
    params += resource_class.serialized_columns.keys.map(&:to_sym)
    params
  end

  index do
    selectable_column
    id_column
    column :enabled
    #column :active
    column :slug
    column :name
    actions
  end

  sidebar_actions = [:show, :edit]

  sidebar "Territories", only: sidebar_actions do
    ul do
      resource.territories.each do |terr|
        li link_to(terr.name, [:admin, resource, terr])
      end
    end
    div link_to("Manage", [:admin, resource, :territories])
  end

  sidebar "Home Regions", only: sidebar_actions do
    ul do
      resource.region_environments.includes{region}.each do |region_environment|
        li region_environment.region.name
      end
    end
    span link_to("Manage", [:admin, resource, :regions])
  end

  sidebar "Permissions", only: sidebar_actions do

    div link_to("Permissions - Individual", [:admin, resource, :user_environments])
    ul do
      resource.user_environments.includes{user}.each do |user_environment|
        li user_environment.title
      end
    end

    div "Permissions - GAP"
  end

  #filter :email
  #filter :current_sign_in_at
  #filter :sign_in_count
  #filter :created_at

  form do |f|
    f.inputs do
      f.input :enabled
      f.input :active_start_date
      f.input :active_end_date

      f.input :slug
      f.input :short_name
      f.input :name
    end
    f.inputs do
      f.input :cas_incident_number
      f.input :dsars_incident_number
      f.input :dr_number
      f.input :arcdata_incident_id
    end
    f.inputs do
      f.object.class.serialized_columns.keys.map(&:to_sym).reduce(nil) do |_, c|
        f.input c
      end
    end
    f.actions
  end

  controller do
    defaults finder: :find_by_slug!
  end

end
