class Host::BaseController < ApplicationController
  private

  def current_shift
    @current_shift ||= Shift.current || raise(ActiveRecord::RecordNotFound, "No shift seeded. Run bin/rails db:seed")
  end
end
