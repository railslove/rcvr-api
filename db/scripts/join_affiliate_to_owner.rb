owners_with_affiliate = Owner.all.select { |owner| owner.affiliate_code }

owners_with_affiliate.each do |owner|
  matching_affiliate = Affiliate.find_by(code: owner.affiliate_code)
  if matching_affiliate
    owner.affiliate = matching_affiliate
    owner.save!
  end
end
