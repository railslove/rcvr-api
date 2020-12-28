class AddPrivacyPolicyLinkToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :privacy_policy_link, :string
  end
end
