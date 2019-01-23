cask 'wlan-intern' do
  version '1.0.1'
  sha256 'a7157728695d2771b71e3bcc02662b8975816b6390d830540b53784b7888207c'

  # 802.1x-config.org was verified as official when first introduced to the cask
  url 'https://802.1x-config.org/user/API.php?action=downloadInstaller&lang=en&id=apple_macos&profile=220'
  name 'Proventa AG, Enterprise Network Configuration "interne MitarbeiterInnen"'
  homepage 'https://pm.proventa.io/projects/it-dokuwiki/wiki/Proventa_WLAN_macOS'

  conflicts_with cask: 'wlan-extern'

  stage_only true

  preflight do
    name = 'Enterprise_Network-macOS-Proventa_AG-interne_MitarbeiterInnen.mobileconfig'
    FileUtils.mv(staged_path.children.first, staged_path / name)
    system_command '/usr/bin/profiles',
                   args: ['install', '-forced', '-path', staged_path / name],
                   sudo: true
  end

  uninstall script: {
                      executable: '/usr/bin/profiles',
                      args:       [
                                    'remove',
                                    '-forced',
                                    '-identifier',
                                    'org.1x-config.enterprise_network.default.proventa_ag.interne_mitarbeiterinnen.en_GB',
                                  ],
                      sudo:       true,
                    }
end
