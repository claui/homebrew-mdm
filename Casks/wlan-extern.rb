cask 'wlan-extern' do
  version '1.0.1'
  sha256 'ad17c3df488872919b62756fdb24a7a16a0b8c0109ad7f9e99278e8808c78d09'

  # 802.1x-config.org was verified as official when first introduced to the cask
  url 'https://802.1x-config.org/user/API.php?action=downloadInstaller&lang=en&id=apple_macos&profile=226'
  name 'Proventa AG, Enterprise Network Configuration "externe MitarbeiterInnen"'
  homepage 'https://pm.proventa.io/projects/it-dokuwiki/wiki/Proventa_WLAN_macOS'

  conflicts_with cask: 'wlan-intern'

  stage_only true

  preflight do
    name = 'Enterprise_Network-macOS-Proventa_AG-externe_MitarbeiterInnen.mobileconfig'
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
                                    'org.1x-config.enterprise_network.default.proventa_ag.externe_mitarbeiterinnen.en_GB',
                                  ],
                      sudo:       true,
                    }
end
