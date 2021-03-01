class AffiliatesCustomTrialPhase < ActiveRecord::Migration[6.0]
  def change
    add_column :affiliates, :custom_trial_phase, :string
  end
end
