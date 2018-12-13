cask 'wlan-intern' do
  version '1.0'
  sha256 '4222ddc548ad14ba0368600196817838a9d2b5076c2bb1d1c5109c6ee7cc2db1'

  # 802.1x-config.org was verified as official when first introduced to the cask
  url 'https://802.1x-config.org/user/API.php?action=downloadInstaller&lang=en&id=apple_macos&profile=220'
  name 'Enterprise Network Configuration Proventa-WLAN für Interne'
  homepage 'https://pm.proventa.io/projects/it-dokuwiki/wiki/Proventa_WLAN_macOS'

  conflicts_with cask: 'wlan-extern'

  stage_only true

  preflight do
    name = 'Enterprise_Network-macOS-Proventa_AG-proventa_Wlan.mobileconfig'
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
                                    'org.1x-config.enterprise_network.default.proventa_ag.proventa_wlan.en_GB',
                                  ],
                      sudo:       true,
                    }
end
