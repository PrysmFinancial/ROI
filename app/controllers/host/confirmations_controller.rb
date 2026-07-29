class Host::ConfirmationsController < Host::BaseController
  include ActionView::RecordIdentifier

  def update
    party = current_shift.parties.find(params[:id])
    Host::UpdateConfirmation.call(party:, status: params[:status])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "confirmation-counts",
            partial: "pages/confirmation_counts",
            locals: { counts: current_shift.confirmation_counts }
          ),
          turbo_stream.replace(
            dom_id(party, :confirmation),
            partial: "pages/confirmation_row",
            locals: { call: party }
          )
        ]
      end
      format.html { redirect_to host_confirmations_path }
    end
  end
end
