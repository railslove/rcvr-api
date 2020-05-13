require 'rails_helper'

RSpec.describe Ticket do
  describe '#mark_cases!' do
    let(:time_range) { 3.hours.ago..2.hours.ago }
    let(:area) { FactoryBot.create(:area) }

    def create_ticket(entered_at, left_at)
      FactoryBot.create(:ticket, area: area, entered_at: entered_at, left_at: left_at)
    end

    it 'Marks overlapping tickets' do
      # overlapping scenarios:
      ticket1 = create_ticket(4.hours.ago, 2.5.hours.ago)
      ticket2 = create_ticket(2.5.hours.ago, 1.hour.ago)
      ticket3 = create_ticket(2.5.hours.ago, 2.6.hours.ago)
      ticket4 = create_ticket(4.hours.ago, 1.hour.ago)

      Ticket.mark_cases!(time_range, area.id)

      expect(ticket1.reload.status).to eq('at_risk')
      expect(ticket2.reload.status).to eq('at_risk')
      expect(ticket3.reload.status).to eq('at_risk')
      expect(ticket4.reload.status).to eq('at_risk')
    end

    it 'Does not touch tickets from other times' do
      ticket1 = create_ticket(4.hours.ago, 3.5.hours.ago)
      ticket2 = create_ticket(1.5.hours.ago, 1.hour.ago)

      Ticket.mark_cases!(time_range, area.id)

      expect(ticket1.reload.status).to eq('neutral')
      expect(ticket2.reload.status).to eq('neutral')
    end

    it 'Does not touch tickets at other companies' do
      ticket1 = FactoryBot.create(:ticket, entered_at: 4.hours.ago, left_at: 1.hour.ago)

      Ticket.mark_cases!(time_range, area.id)

      expect(ticket1.reload.status).to eq('neutral')
    end
  end

  context "WriteOnceOnlyValidator" do
    it "Can write if empty" do
      ticket = FactoryBot.create(:ticket, entered_at: nil)

      ticket.entered_at = Time.zone.now

      expect(ticket.valid?).to be(true)
    end

    it "Can't write if already written" do
      ticket = FactoryBot.create(:ticket, entered_at: 1.hour.ago)

      ticket.entered_at = Time.zone.now

      expect(ticket.valid?).to be(false)
    end

    it "Can write other attributes" do
      ticket = FactoryBot.create(:ticket, entered_at: 1.hour.ago, left_at: nil)

      ticket.left_at = Time.zone.now

      expect(ticket.valid?).to be(true)
    end
  end
end
