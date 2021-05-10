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

  context "Update encrypted data" do

    it "can update encrypted data and keeps versions" do
      ticket = FactoryBot.create(:ticket, entered_at: 1.hour.ago, left_at: nil)

      original = ticket.encrypted_data

      expect(ticket.encrypted_data.nil?).to be(false)
      expect(ticket.encrypted_data_change_history.length).to be(0)

      ticket.encrypted_data = 'abc'
      ticket.save

      expect(ticket.encrypted_data).to eql('abc')
      expect(ticket.encrypted_data_change_history).to_not be(nil)
      expect(ticket.encrypted_data_change_history.length).to be(1)
      expect(ticket.encrypted_data_change_history.first).to eq(original)
    end

  end

  it "should expose the company cwa url" do
    company = FactoryBot.create(:company, name: "Example Inc", location_type: :public_building, street: "Example Str. 2", zip: "10223", city: "Berlin", cwa_crypto_seed: "\x9E\x1C\x85\xDDq WL}C\xD8\xDA?\xB7ih", cwa_link_enabled: true)
    ticket = FactoryBot.create(:ticket, entered_at: 1.hour.ago, left_at: 30.minutes.ago, company: company)
    expect(ticket.company_cwa_url).to eql("https://e.coronawarn.app?v=1#CAESLQgBEgtFeGFtcGxlIEluYxocRXhhbXBsZSBTdHIuIDIsIDEwMjIzIEJlcmxpbhqXAQgBEoABZ3dMTXpFMTUzdFF3QU9mMk1ab1VYWGZ6V1RkbFNwZlM5OWlaZmZtY214T0c5bmpTSzRSVGltRk9Gd0RoNnQwVHl3OFhSMDF1Z0RZanR1S3dqanVLNDlPaDgzRldjdDZYcGVmUGk5U2tqeHZ2ejUzaTlnYU1tVUVjOTZwYnRvYUEaEJ4chd1xIFdMfUPY2j-3aWgiBwgBEAgY8AE=")
  end

end
