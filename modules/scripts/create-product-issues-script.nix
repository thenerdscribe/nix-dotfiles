{ pkgs, ... }:
pkgs.writeShellScriptBin "issues-script" ''
  set -e;
  trap INT;

  function format_error() {
      ${pkgs.gum}/bin/gum style \
          --foreground 212 \
          --padding "0 2" \
          --border-foreground 12 --border double \
          --align center \
          $1;
  }
  function format_success() {
      ${pkgs.gum}/bin/gum  style \
          --foreground 6 \
          --padding "0 2" \
          --border-foreground 12 --border double \
          --align center \
          $1;
  }

  # Get what date to search on
  today=`date -I`;
  search=`${pkgs.gum}/bin/gum input --header="Enter date to search:"  --value="$today"`;
  filesearch=`${pkgs.fd}/bin/fd "$search" | ${pkgs.ripgrep}/bin/rg 'product_issues'` || echo "";

  if [[ -n "$filesearch" ]]; then
      filename=`echo $filesearch | ${pkgs.gum}/bin/gum choose --limit=1 --header="Select a file to create script for:"`;
  else
      format_error "No files match $search";
      exit 1;
  fi;

  filedate="$(echo $filename | ${pkgs.ripgrep}/bin/rg -oe '\d{4}-\d{2}-\d{2}')";

  if [[ -f "update-gmc-$filedate.sh" ]]; then
      format_error "Script already exists for $filedate";
      exit 1;
  fi;

  models="$(cut -d ',' -f 1 < $filename | sort -u | ${pkgs.ripgrep}/bin/rg -v 'Item ID')";
  outfile="update-gmc-$filedate.sh";

  # Echo out how many models exist in the CSV
  entrants=`echo $models | wc -l | cut -f1 -d ' '`;

  format_success "$outfile will have $entrants entries";

  # Make the shell script
  ${pkgs.gum}/bin/gum confirm "Create file?" &&
      echo "php artisan command:update-primary-listing-skus-on-google-merchant-center $models" | tr "\n" " " > $outfile || exit;

  format_success "$outfile was created";

  gum confirm "Upload to ecomm site?" && scp $outfile awesome:~/gmc/ || format_error  "Did not upload $outfile to web server";
''
