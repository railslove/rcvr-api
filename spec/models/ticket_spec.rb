require 'rails_helper'

RSpec.describe Ticket do
  describe '#during' do
    let(:time_range) { 4.hours.ago..2.hours.ago }

    subject { Ticket.during(time_range) }

    let(:open_ticket_before_end) { FactoryBot.create(:ticket, entered_at: 3.hours.ago, left_at: nil) }
    let(:open_ticket_after_end) { FactoryBot.create(:ticket, entered_at: 1.hour.ago, left_at: nil) }
    let(:overlapping_tickets) do
      [
        FactoryBot.create(:ticket, entered_at: time_range.begin - 1.hour, left_at: time_range.end - 1.hour),
        FactoryBot.create(:ticket, entered_at: time_range.begin + 1.hour, left_at: time_range.end + 1.hour),
        FactoryBot.create(:ticket, entered_at: time_range.begin + 1.hour, left_at: time_range.end - 1.hour),
        FactoryBot.create(:ticket, entered_at: time_range.begin - 1.hour, left_at: time_range.end + 1.hour)
      ]
    end
    let(:non_overlapping_tickets) do
      [
        FactoryBot.create(:ticket, entered_at: time_range.begin - 2.hours, left_at: time_range.begin - 1.hour),
        FactoryBot.create(:ticket, entered_at: time_range.end + 1.hour, left_at: time_range.end + 2.hours)
      ]
    end

    it { is_expected.to include(open_ticket_before_end) }
    it { is_expected.not_to include(open_ticket_after_end) }
    it { is_expected.to include(*overlapping_tickets) }
    it { is_expected.not_to include(*non_overlapping_tickets) }
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
