require 'rails_helper'

RSpec.describe Ticket do
  describe '.mark_as_confirmed!' do
    let(:ticket0) { FactoryBot.create(:ticket, entered_at: 3.hours.ago, left_at: 2.hours.ago) }

    def create_ticket(entered_at, left_at)
      FactoryBot.create(:ticket, company: ticket0.company, entered_at: entered_at,
                                 left_at: left_at)
    end

    it 'Marks the ticket as confirmed' do
      expect { ticket0.mark_as_confirmed! }
        .to change { ticket0.status }.from('neutral').to('confirmed')
    end

    it 'Marks overlapping tickets' do
      # overlapping scenarios:
      ticket1 = create_ticket(4.hours.ago, 2.5.hours.ago)
      ticket2 = create_ticket(2.5.hours.ago, 1.hour.ago)
      ticket3 = create_ticket(2.5.hours.ago, 2.6.hours.ago)
      ticket4 = create_ticket(4.hours.ago, 1.hour.ago)

      ticket0.mark_as_confirmed!

      expect(ticket1.reload.status).to eq('at_risk')
      expect(ticket2.reload.status).to eq('at_risk')
      expect(ticket3.reload.status).to eq('at_risk')
      expect(ticket4.reload.status).to eq('at_risk')
    end

    it 'Does not touch tickets from other times' do
      ticket1 = create_ticket(4.hours.ago, 3.5.hours.ago)
      ticket2 = create_ticket(1.5.hours.ago, 1.hour.ago)

      ticket0.mark_as_confirmed!

      expect(ticket1.reload.status).to eq('neutral')
      expect(ticket2.reload.status).to eq('neutral')
    end

    it 'Does not touch tickets at other companies' do
      ticket1 = FactoryBot.create(:ticket, entered_at: 4.hours.ago, left_at: 1.hour.ago)

      ticket0.mark_as_confirmed!

      expect(ticket1.reload.status).to eq('neutral')
    end
  end
end
