function build_apk(){
  flutter clean
  flutter build apk
}

function build_apk_per_abi(){
  flutter clean
  flutter build apk --split-per-abi
}


function build_aab(){
  flutter clean
  flutter build appbundle
}


function push_to_firebase_split(){
  build_apk_per_abi

  result=$(is_unix)
  path=$(pwd)
  case "$result" in
  "1")   path="$path/build/app/outputs/apk/release/app-armeabi-v7a-release.apk";;   # forward-slash
  "0")   path="$path\build\app\outputs\flutter-apk\app-release.apk" ;;  # backward-slash
  *)        exit  0  ;;
  esac


  printf "Enter desc: "
  read desc
#  printf "Enter group (all, appDevGroup, test): "
  group="test"

  cd android
#  sudo bundle update
  firebase login
  bundle exec fastlane beta group:"$group" desc:"$desc" project_root:"$path"
  cd ..
}

function push_to_firebase(){
  printf "Enter desc: "
  read desc
  printf "Enter group (all, appDevGroup, test): "
  read group


  build_apk

  result=$(is_unix)
  path=$(pwd)
  case "$result" in
  "1")   path="$path/build/app/outputs/flutter-apk/app-release.apk";;   # forward-slash
  "0")   path="$path\build\app\outputs\flutter-apk\app-release.apk" ;;  # backward-slash
  *)        exit  0  ;;
  esac


#  printf "Enter desc: "
#  read desc
#  printf "Enter group (all, appDevGroup, test): "
#  read group

  echo "before cd"
  cd android
#  echo "before bundle update"
#  sudo bundle update
  echo "before firebase login"
  firebase login
bundle exec fastlane beta group:"$group" desc:"$desc" project_root:"$path"```12`
  cd ..
}


function is_unix(){
  case "$OSTYPE" in
#  *darwin*|*DARWIN*) echo "1" ;;   #  forward-slash
  linux*|LINUX*)   echo "1" ;;   #  forward-slash
#  mingw*|msys*|CYGWIN*|MINGW32*|MSYS*|MINGW*)    echo "0" ;;   #  backward-slash
  *)        exit  0  ;;
  esac
}

function check_bunlder(){
    isInstalled=$(type bundle)
    case "$isInstalled" in
      *not*) install_linux;;
    esac

}

function install_linux(){
  #linux distro
  programs=(rubygems ruby-devel)
  echo "Following will be installed..."
  for u in "${programs[@]}"
  do
    echo  "* $u"
  done
  echo  "* bundler";echo "* firebase CLI";


  printf "Do you want to continue (y)? [install manually if only 1-2 missing as it will consume more time and net ] "
  read choice

  if [[ "$choice" != "y" ]]
    then
      exit 0
  fi


  declare -A osInfo;
  osInfo[/etc/debian_version]="apt-get install -y"
  osInfo[/etc/alpine-release]="apk --update add"
  osInfo[/etc/centos-release]="yum install -y"
  osInfo[/etc/fedora-release]="dnf install -y"

  for f in ${!osInfo[@]}
  do
      if [[ -f $f ]];then
          package_manager=${osInfo[$f]}
          echo "$f detected"
      fi
  done


  for u in "${programs[@]}"
  do
    sudo ${package_manager} $u
  done
    gem install bundler
    curl -sL https://firebase.tools | bash


  printf "Do you want to continue (y) [Please do not if anything broke] ? "
  read choice
  if [[ "$choice" != "y" ]]
    then
      exit 0
  fi


}


case $1 in
    "firebase") push_to_firebase; exit;;
    "firebase-test") push_to_firebase_split; exit;;
    "aab") build_aab; exit;;
    "apk") build_apk; exit;;
    "apk abi") build_apk_per_abi; exit;;
    "install_linux") install_linux; exit;;
esac