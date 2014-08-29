require_dependency "iap/application_controller"

module Iap
  class WorkAssignmentsController < ApplicationController
    inherit_resources
    belongs_to :environment, finder: :find_by_slug!
    belongs_to :plan, finder: :find_by_number!
    defaults route_prefix: nil
    actions :all, except: :show
    custom_actions resource: [:duplicate], collection: [:print]
    respond_to :html
    respond_to :pdf, only: :print
    before_filter :set_content_disposition

    def smart_resource_url
      edit_resource_path
    end

    def duplicate
      new_resource = resource.duplicate
      new_resource.save
      redirect_to edit_resource_path(new_resource)
    end

    protected

    def set_content_disposition
      if request.env['Rack-Middleware-PDFKit']
        filename = "#{current_environment.dr_number} IAP #{parent.number} ICS 204.pdf"
        response.headers['Content-Disposition'] = "inline; filename=\"#{filename}\""
      end
    end

    def add_breadcrumbs
      super
      breadcrumb parent.to_breadcrumb, parent_path
      breadcrumb "Work Assignments", (params[:action] != 'index' && collection_path)
      breadcrumb (resource.activity || "New Assignment") if params[:id]
      breadcrumb "Print" if params[:action]=='print'
    end

    def build_resource_params
      [params.fetch(:work_assignment, {}).permit(:group, :activity, :district, :section_chief_name, :section_chief_phone,
              :activity_manager_phone, :activity_manager_name, :supervisor_name, :supervisor_phone, :work_assignments,
              :special_instructions, :prepared_by_name, :prepared_by_title,
              work_assignment_lines_attributes: [:resource_identifier, :leader, :num_persons, :contact, :reporting_location, :ordinal, :_destroy, :id])]
    end

    def editable
      true
    end
    helper_method :editable
  end
end
