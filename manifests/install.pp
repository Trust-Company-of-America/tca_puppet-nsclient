# == Class: nsclient::install
#
# Class to install the nsclient msi

class nsclient::install {

  validate_string($nsclient::package_source_location)
  validate_string($nsclient::package_name)

  $source = "${nsclient::package_source_location}/${nsclient::package_name}"

  case downcase($::osfamily) {
    'windows': {

      file { $nsclient::download_destination:
        ensure => directory,
      }

      download_file { 'NSCP-Installer':
        url                   => $source,
        destination_directory => $nsclient::download_destination,
        require               => File[$nsclient::download_destination]
      }

      package { $nsclient::package_name:
        ensure   => installed,
        source   => "${nsclient::download_destination}\\${nsclient::package_name}",
        provider => 'windows',
        require  => Download_file['NSCP-Installer']
      }
    }
    default: {
      fail('This module only works on Windows based systems.')
    }
  }
}
