cask 'wlan-extern' do
  version '1.0'
  sha256 '2650d872691e6ef7a8d951a40154fb289aa1776cd6a75302ba9ad228078a78ff'

  # 802.1x-config.org was verified as official when first introduced to the cask
  url 'https://802.1x-config.org/user/API.php?action=downloadInstaller&lang=en&id=apple_macos&profile=226'
  name 'Enterprise Network Configuration Proventa-WLAN für Externe'
  homepage 'https://pm.proventa.io/projects/it-dokuwiki/wiki/Proventa_WLAN_macOS'

  conflicts_with cask: 'wlan-intern'

  stage_only true

  preflight do
    name = 'Enterprise_Network-macOS-Proventa_AG-proventa_ext_Wlan.mobileconfig'
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
                                    'org.1x-config.enterprise_network.default.proventa_ag.proventa_ext_wlan.en_GB',
                                  ],
                      sudo:       true,
                    }
end
