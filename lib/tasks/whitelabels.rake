namespace :whitelabels do
  desc 'setup default whitelabel configurations'
  task :setup => :environment do
    setup_rcvr
    setup_care
    setup_fresenius
  end

  def setup_rcvr
    frontend = Frontend.find_by(name: 'rcvr.app')
    return unless frontend.present? && frontend.whitelabel.blank?

    new_wl = Whitelabel.create({
      name: 'rcvr',
      primary_highlight_color: '#28EE5F',
      secondary_highlight_color: '#EA28EE',
      logo_small_width: '61px',
      logo_small_height: '10px',
      logo_big_width: '182px',
      logo_big_height: '20px',
      formal_address: false,
      intro_text: 'Durch die aktuellen Corona-Verordnungen musst du deine Kontaktdaten hinterlegen, wenn Du in einem Betrieb bist der zu Schutzmaßnahmen verpflichtet ist, wie z.B Restaurants. Die App kann auch freiwillig genutzt werden, um die Nachverfolgung zu unterstützen.',
    })
    frontend.update(whitelabel: new_wl)
  end

  def setup_care
    frontend = Frontend.find_by(name: 'recover care')
    return unless frontend.present? && frontend.whitelabel.blank?

    new_wl = Whitelabel.create({
      name: 'recover care',
      background_color: '#f2f2f2',
      primary_highlight_color: '#F5B743',
      logo_small_width: '92px',
      logo_small_height: '10px',
      logo_big_width: '120px',
      logo_big_height: '20px',
      formal_address: true,
      intro_text: 'Durch die aktuellen Corona-Verordnungen müssen Sie Ihre Kontaktdaten hinterlegen, wenn Sie in einem Betrieb sind der zu Schutzmaßnahmen verpflichtet ist, wie z.B Pflegeeinrichtungen. Die App kann auch freiwillig genutzt werden, um die Nachverfolgung zu unterstützen.',
    })
    frontend.update(whitelabel: new_wl)
  end

  def setup_fresenius
    frontend = Frontend.find_by(name: 'recover fresenius')
    return unless frontend.present? && frontend.whitelabel.blank?

    new_wl = Whitelabel.create({
      name: 'recover fresenius',
      background_color: '#A6D7D7',
      primary_highlight_color: '#009EE0',
      logo_small_width: '150px',
      logo_small_height: '66px',
      logo_big_width: '300px',
      logo_big_height: '130px',
      formal_address: true,
      privacy_url: 'https://www.hs-fresenius.de/datenschutzerklaerung-recover-app/',
      intro_text: 'Bitte geben Sie Ihre Kontaktdaten ein, wenn Sie sich in diesem Raum aufhalten. Dies ist Teil der verpflichtenden Hygiene- und Schutzmaßnahmen am Campus und dient der Nachverfolgung in einem Infektionsfall.',
    })
    frontend.update(whitelabel: new_wl)
  end
end
