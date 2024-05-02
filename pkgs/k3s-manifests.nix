{ stdenv }:
stdenv.mkDerivation {
  name = "k3s-manifests";
  src = .fetchGit {
    url = "https://github.com/kube-vip/kube-vip.git";
    ref = "main";
    rev = "2872256a89a1e39b62c9518728ec22e2f33af4eb";
  };

  executable = ''
    ls -al
    cp ./manifests /var/lib/rancher/k3s/server/manifests
  '';
}
