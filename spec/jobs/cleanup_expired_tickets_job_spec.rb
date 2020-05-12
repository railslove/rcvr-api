require 'rails_helper'

RSpec.describe CleanupExpiredTicketsJob, type: :job do
  subject(:run_job) { described_class.perform_now }

  let!(:expired_ticket) { FactoryBot.create(:ticket, :with_data, created_at: 15.week.ago, status: :expired) }
  let!(:ancient_ticket) { FactoryBot.create(:ticket, :with_data, created_at: 5.week.ago) }
  let!(:old_ticket) { FactoryBot.create(:ticket, :with_data, created_at: 4.week.ago) }
  let!(:not_yet_old_ticket) { FactoryBot.create(:ticket, :with_data, created_at: 3.week.ago) }

  it 'removes user data from ancient ticket' do
    expect { run_job }.to change { ancient_ticket.reload.encrypted_data }.from(anything).to(nil)
  end

  it 'removes public key from ancient ticket' do
    expect { run_job }.to change { ancient_ticket.reload.public_key }.from(anything).to(nil)
  end

  it 'expires ancient ticket' do
    expect { run_job }.to change { ancient_ticket.reload.status }.from('neutral').to('expired')
  end

  it 'removes user data from old ticket' do
    expect { run_job }.to change { old_ticket.reload.encrypted_data }.from(anything).to(nil)
  end

  it 'removes public key from old ticket' do
    expect { run_job }.to change { old_ticket.reload.public_key }.from(anything).to(nil)
  end

  it 'expires old ticket' do
    expect { run_job }.to change { old_ticket.reload.status }.from('neutral').to('expired')
  end

  it 'does not remove user data from old ticket' do
    expect { run_job }.not_to change { not_yet_old_ticket.reload.encrypted_data }
  end

  it 'does not remove public key from old ticket' do
    expect { run_job }.not_to change { not_yet_old_ticket.reload.public_key }
  end

  it 'does not expire old ticket' do
    expect { run_job }.not_to change { not_yet_old_ticket.reload.status }
  end

  it 'does not change expired ticket' do
    expect { run_job }.not_to change { expired_ticket.reload.attributes }
  end
end
