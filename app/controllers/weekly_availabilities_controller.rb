class WeeklyAvailabilitiesController < ApplicationController
  def new_fields
    @index = params[:index].to_i
    @wa = WeeklyAvailability.new
    render partial: "weekly_availabilities/fields", locals: { f: dummy_form_builder(@wa, @index) }
  end

  private

  # Needed because we're rendering a field partial outside of the usual form builder
  def dummy_form_builder(object, index)
    user = current_user
    user.weekly_availabilities.build if user.weekly_availabilities.empty?
    form = ActionView::Helpers::FormBuilder.new(:user, user, self, {})
    nested_form = form.simple_fields_for(:weekly_availabilities, object, child_index: index) do |wa_form|
      return wa_form
    end
  end
end
