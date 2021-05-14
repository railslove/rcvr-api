Affiliate.destroy_all
Owner.destroy_all

7.times do
  FactoryBot.create(:affiliate)
end
affiliates = Affiliate.all
affiliates.each { |affiliate| puts "#{affiliate.name} #{affiliate.code}" }

20.times do
  FactoryBot.create(:owner)
end
owners = Owner.all
owners.each { |owner| puts owner.name }


# give 9 owners an affilate
owners_with_affiliates = owners[0..8]
owners_with_affiliates.each do |owner|
  owner.update!(affiliate_code: affiliates.sample.code)
end

# give 3 owners affiliates which are not yet entities in the db
owners_with_other_affiliates = owners[9..11]
owners_with_other_affiliates.each do |owner|
  owner.update!(affiliate_code: affiliates.sample.code.prepend('a').chop)
end
