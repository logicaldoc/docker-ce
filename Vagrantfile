Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 3072
    v.cpus = 2    
    config.vm.network "forwarded_port", guest: 8080, host: 8080
  end

  config.vm.define :dockerhost do |config|
    config.vm.box = "bento/debian-8.6"

    if ENV["apt_proxy"]
      config.vm.provision "shell", inline: <<-EOF
        echo "Acquire::http::Proxy \\"#{ENV['apt_proxy']}\\";" >/etc/apt/apt.conf.d/50proxy
        echo "apt_proxy=\"#{ENV['apt_proxy']}\"" >/etc/profile.d/apt_proxy.sh
      EOF
    end

    config.vm.provision "shell", env: {"apt_proxy" => ENV["apt_proxy"]}, inline: <<-EOF
      set -e
      export DEBIAN_FRONTEND=noninteractive
      echo "en_US.UTF-8 UTF-8" >/etc/locale.gen
      locale-gen
      echo "Apt::Install-Recommends 'false';" >/etc/apt/apt.conf.d/02no-recommends
      echo "Acquire::Languages { 'none' };" >/etc/apt/apt.conf.d/05no-languages
      apt-get update
      apt-get -y autoremove --purge
      wget -qO- https://get.docker.com/ | sh
      sudo usermod -aG docker vagrant
      cd /vagrant

      if [ $apt_proxy ]; then
        docker build -t logicaldoc/logicaldoc-ce --build-arg APT_PROXY=$apt_proxy .
      else
        docker build -t logicaldoc/logicaldoc-ce .
      fi

      #docker run --rm -v logicaldoc-repo:/opt/logicaldoc/repository -v logicaldoc-conf:/opt/logicaldoc/conf logicaldoc/logicaldoc-ce
      docker run -d --name logicaldocce --restart=always -p 8080:8080 -v logicaldoc-repo:/opt/logicaldoc/repository -v logicaldoc-conf:/opt/logicaldoc/conf logicaldoc/logicaldoc-ce
    EOF
  end
end
