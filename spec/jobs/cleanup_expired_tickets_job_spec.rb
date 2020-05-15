require 'rails_helper'

RSpec.describe CleanupExpiredTicketsJob, type: :job do
  subject(:run_job) { described_class.perform_now }

  let(:long_expired_ticket) { FactoryBot.create(:ticket, created_at: 5.week.ago) }
  let(:edgecase_expired_ticket) { FactoryBot.create(:ticket, created_at: 4.week.ago) }
  let(:not_expired_ticket) { FactoryBot.create(:ticket, created_at: 3.week.ago) }

  it { expect { run_job }.to change { Ticket.exists?(edgecase_expired_ticket.id) }.from(true).to(false) }
  it { expect { run_job }.to change { Ticket.exists?(long_expired_ticket.id) }.from(true).to(false) }
  it { expect { run_job }.not_to change { Ticket.exists?(not_expired_ticket.id) } }
end
