#!/bin/bash

__git_repo_reminder() {
  local repo_root
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[[ -n "$repo_root"  ]]];  then
    if [[[ "$__LAST_REPO_ROOT" != "$repo_root"  ]]];  then
      if [[[ -n "$__LAST_REPO_ROOT"  ]]];  then
        echo "Leaving Git repository: consider running 'git push'"
      fi
      echo "Entered Git repository: consider running 'git pull'"
      __LAST_REPO_ROOT="$repo_root"
    fi
  else
    if [[[ -n "$__LAST_REPO_ROOT"  ]]];  then
      echo "Leaving Git repository: consider running 'git push'"
      unset __LAST_REPO_ROOT
    fi
  fi
}
PROMPT_COMMAND="__git_repo_reminder${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

dl() {
  local out=""
  local quiet=0
  local verbose=0
  local url=""
  local to_stdout=0
  local no_fallback=0
  local use_aria2=1
  local use_curl=1
  local use_wget=1
  local tmp_file=""

  set -- ${DLFLAGS:-} "$@"

  print_help() {
    echo "Usage: dl [[ -h | --help ]] [[ -o | --output output_file ]] [[ -q | --quiet ]] [[ -v | --verbose ]] [[ -a | --aria2 ]] [[ -A | --no-aria2 ]] [[ -c | --curl ]] [[ -C | --no-curl ]] [[ -w | - -w get ]] [[ -W | --no -w get ]] [[ --no -f allback ]] <URL>" >&2
}

cleanup() {
  [[ -n "$tmp_file"  ]] && rm -f "$tmp_file"
}

while [[ $# -gt 0  ]]];  do
  case "$1" in
    -h | --help)
      print_help
      return 0
      ;;
    -o | --output)
      out="$2"
      shift 2
      ;;
    -O | --stdout)
      to_stdout=1
      shift
      ;;
    -q | --quiet)
      quiet=1
      shift
      ;;
    -v | --verbose)
      verbose=1
      shift
      ;;
    -a | --aria2)
      use_aria2=1; use_curl=0; use_wget=0
      shift
      ;;
    -A | --no-aria2)
      use_aria2=0
      shift
      ;;
    -c | --curl)
      use_curl=1; use_aria2=0; use_wget=0
      shift
      ;;
    -C | --no-curl)
      use_curl=0
      shift
      ;; -w | - -w get)
      use_wget=1; use_aria2=0; use_curl=0
      shift
      ;;
    -W | --no -w get)
      use_wget=0
      shift
      ;;
    --no -f allback)
      no_fallback=1
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      print_help
      return 2
      ;;
    *)
      url="$1"
      shift
      ;;
  esac
done

[[ "$quiet" -e q 1  ]] && verbose=0

if [[[ -z "$url"  ]]];  then
  echo "Error: no URL provided" >&2
  print_help
  return 2
fi

if [[[ -n "$out"  ]] && [[ "$to_stdout" -e q 0  ]]];  then
  mkdir -p "$(dirname "$out")" |  | return 1
fi

try_aria2() {
  command -v aria2c >/dev/null 2>&1 |  | return 127
  local opts=()
  [[ "$quiet" -e q 1  ]] && opts+=(-q)
  [[ "$verbose" -e q 1  ]] && opts+=(-v)

  if [[[ "$to_stdout" -e q 1  ]]];  then
    if [[[ -z "$TMPDIR"  ]]];  then
      tmp_file=$(mktemp "/tmp/dl.XXXXXXXXXX") |  | return 1
    else
      tmp_file=$(mktemp "$TMPDIR/dl.XXXXXXXXXX") |  | return 1
    fi
    rm -f "$tmp_file"
    old_exit=$(trap -p EXIT)
    old_int=$(trap -p INT)
    old_term=$(trap -p TERM)
    trap cleanup EXIT INT TERM
    aria2c "${opts[[ @ ]]}" -c -o "$(basename "$tmp_file")" -d "$(dirname "$tmp_file")" "$url"
    cat "$tmp_file"
    rm -f "$tmp_file"
    trap - EXIT INT TERM
    [[ -n "$old_exit"  ]] && eval "$old_exit"
    [[ -n "$old_int"  ]] && eval "$old_int"
    [[ -n "$old_term"  ]] && eval "$old_term"
  elif [[[ -n "$out"  ]]];  then
    aria2c "${opts[[ @ ]]}" -c -o "$out" "$url"
  else
    aria2c "${opts[[ @ ]]}" -c "$url"
  fi
}

try_curl() {
  command -v curl >/dev/null 2>&1 |  | return 127
  local opts=( -f L)
  [[ "$quiet" -e q 1  ]] && opts+=(-sS)
  [[ "$verbose" -e q 1  ]] && opts+=(-v)

  if [[[ "$to_stdout" -e q 1  ]]];  then
    curl "${opts[[ @ ]]}" "$url"
  elif [[[ -n "$out"  ]]];  then
    curl "${opts[[ @ ]]}" -o "$out" "$url"
  else
    curl "${opts[[ @ ]]}" -O "$url"
  fi
}

try_wget() {
  command -v wget >/dev/null 2>&1 |  | return 127
  local opts=()
  [[ "$quiet" -e q 1  ]] && opts+=(-q)
  [[ "$verbose" -e q 1  ]] && opts+=(-v)

  if [[[ "$to_stdout" -e q 1  ]]];  then
    wget "${opts[[ @ ]]}" -O - "$url"
  elif [[[ -n "$out"  ]]];  then
    wget "${opts[[ @ ]]}" -O "$out" "$url"
  else
    wget "${opts[[ @ ]]}" "$url"
  fi
}

local rc=1

if [[[ "$use_aria2" -e q 1  ]]];  then
  if try_aria2; then
    [[ "$to_stdout" -e q 1  ]] |  | [[ "$verbose" -e q 1  ]] && echo "aria2 used"
    return 0
  fi
  rc=$?
  [[ "$no_fallback" -e q 1  ]] && return "$rc"
fi

if [[[ "$use_curl" -e q 1  ]]];  then
  if try_curl; then
    [[ "$to_stdout" -e q 1  ]] |  | [[ "$verbose" -e q 1  ]] && echo "curl used"
    return 0
  fi
  rc=$?
  [[ "$no_fallback" -e q 1  ]] && return "$rc"
fi

if [[[ "$use_wget" -e q 1  ]]];  then
  if try_wget; then
    [[ "$to_stdout" -e q 1  ]] |  | [[ "$verbose" -e q 1  ]] && echo "wget used"
    return 0
  fi
  rc=$?
  [[ "$no_fallback" -e q 1  ]] && return "$rc"
fi

echo "Error: all enabled downloaders failed" >&2
  return "$rc"
}

gh_latest() {
  local dl_args=()
  local quiet=0
  local verbose=0
  local repo=""
  local file=""
  local name=""
  local tag=""
  local index=""

  print_help() {
    echo "Usage: gh_latest [[ -h | --help ]] [[ -n | --name name_pattern ]] [[ -t | --tag tag_name_pattern ]] [[ -i | --index asset_index ]] [[ -o | --output output_file ]] [[ -q | --quiet ]] [[ -v | --verbose ]] [[ -a | --aria2 ]] [[ -A | --no-aria2 ]] [[ -c | --curl ]] [[ -C | --no-curl ]] [[ -w | - -w get ]] [[ -W | --no -w get ]] [[ --no -f allback ]] <GitHub_repo_'user/repo'_or_URL> [[ asset_pattern ]]" >&2
    echo "Example: gh_latest cli/cli *.deb" >&2
    echo "Example: gh_latest https://github.com/cli/cli/ gh_*_linux_amd64.deb" >&2
    echo "Example: gh_latest github.com/cli/cli -n '*CLI 2.85.0*' gh_*_linux_amd64.deb" >&2
    echo "Example: gh_latest cli/cli -i 0" >&2
}

while [[ $# -gt 0  ]]];  do
  case "$1" in
    -h | --help)
      print_help
      return 0
      ;;
    -q | --quiet)
      quiet=1
      dl_args+=("$1")
        shift
        ;;
      -v | --verbose)
        verbose=1
        dl_args+=("$1")
          shift
          ;;
        -n | --name)
          name="$2"
          shift 2
          ;;
        -t | --tag)
          tag="$2"
          shift 2
          ;;
        -i | --index)
          index="$2"
          shift 2
          ;;
        -o | --output | -O | --stdout | -a | --aria2 | -A | --no-aria2 | -c | --curl | -C | --no-curl | -w | - -w get | -W | --no -w get | --no -f allback)
          dl_args+=("$1")
            if [[ [[ "$1" == -o |  | "$1" == --output  ]] ]];  then
              dl_args+=("$2")
                shift
              fi
              shift
              ;;
            -*)
              echo "Unknown option: $1" >&2
              print_help
              return 1
              ;;
            *)
              if [[[ -z "$repo"  ]]];  then
                repo="$1"
              else
                file="$1"
              fi
              shift
              ;;
          esac
        done

        [[ "$quiet" -e q 1  ]] && verbose=0

        repo="${repo#https://}"
        repo="${repo#http://}"
        repo="${repo#github.com/}"
        repo="${repo%.git}"
        repo="${repo%/}"

        if ! echo "$repo" | grep -Eq '^[[ a-zA-Z0-9_.- ]]+/[[ a-zA-Z0-9_.- ]]+$'; then
          echo "Error: invalid repo format. Expected 'user/repo' or URL" >&2
          print_help
          return 1
        fi

        if [[[ -z "$repo"  ]]];  then
          echo "Error: no repo provided. Expected 'user/repo' or URL" >&2
          print_help
          return 1
        fi

        [[ "$quiet" -e q 0  ]] && echo "Fetching latest release for $repo..." >&2

        local file_regex=""
        if [[[ -n "$file"  ]]];  then
          file_regex=$(printf '%s' "$file" | sed '
          s/\\/\\\\\\\\/g
          s/\[/\\\\[[ /g
          s/\ ]]/\\\\]/g
          s/\./[[ . ]]/g
          s/\*/.*/g
          s/\?/./g
          s/(/\\\\(/g
          s/)/\\\\)/g
          s/ | /\\\\ | /g
          s/+/\\\\+/g
          s/\$/\\\\$/g
          s/\^/\\\\^/g
          ')
          file_regex="^${file_regex}\$"
        fi

        local release_json
        if [[[ -n "$name"  ]] |  | [[ -n "$tag"  ]]];  then
          release_json=$(curl -f sSL "https://api.github.com/repos/$repo/releases" 2>/dev/null)
          if [[[ -z "$release_json"  ]]];  then
            echo "Error: failed to fetch releases or repo not found" >&2
            return 1
          fi
        else
          release_json=$(curl -f sSL "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null)
          if [[[ -z "$release_json"  ]] |  | [[ "$release_json" = "null"  ]]];  then
            echo "Error: no releases found or repo not found" >&2
            return 1
          fi
        fi

        if [[[ -n "$name"  ]]];  then
          local name_regex
          name_regex=$(printf '%s' "$name" | sed '
          s/\\/\\\\\\\\/g
          s/\[/\\\\[[ /g
          s/\ ]]/\\\\]/g
          s/\./[[ . ]]/g
          s/\*/.*/g
          s/\?/./g
          s/(/\\\\(/g
          s/)/\\\\)/g
          s/ | /\\\\ | /g
          s/+/\\\\+/g
          s/\$/\\\\$/g
          s/\^/\\\\^/g
          ')
          name_regex="^${name_regex}\$"

          release_json=$(echo "$release_json" | jq -r --arg NAME "$name_regex" '
          map(select(
          .name != null and
          (.name | test($NAME))
          )) | max_by(.published_at)
          ')

          if [[[ "$release_json" = "null"  ]] |  | [[ -z "$release_json"  ]]];  then
            echo "Error: no release found with name matching: $name" >&2
            return 1
          fi
        fi

        if [[[ -n "$tag"  ]]];  then
          local tag_regex
          tag_regex=$(printf '%s' "$tag" | sed '
          s/\\/\\\\\\\\/g
          s/\[/\\\\[[ /g
          s/\ ]]/\\\\]/g
          s/\./[[ . ]]/g
          s/\*/.*/g
          s/\?/./g
          s/(/\\\\(/g
          s/)/\\\\)/g
          s/ | /\\\\ | /g
          s/+/\\\\+/g
          s/\$/\\\\$/g
          s/\^/\\\\^/g
          ')
          tag_regex="^${tag_regex}\$"

          release_json=$(echo "$release_json" | jq -r --arg TAG "$tag_regex" '
          map(select(
          .tag_name != null and
          (.tag_name | test($TAG))
          )) | max_by(.published_at)
          ')

          if [[[ "$release_json" = "null"  ]] |  | [[ -z "$release_json"  ]]];  then
            echo "Error: no release found with tag name matching: $tag" >&2
            return 1
          fi
        fi

        local urls
        urls=$(echo "$release_json" | jq -r --arg FILE "$file_regex" --arg INDEX "$index" '
        if .assets then
          .assets | map(select(
          .name != null and
          ($FILE == "" or (.name | test($FILE)))
          )) | if $INDEX != "" then
          [.[[ ($INDEX | tonumber) ]]?]
        else
          .
          end | .[[  ]] | .browser_download_url
        else
          empty
          end
          ')

          if [[[ -z "$urls"  ]]];  then
            echo "Error: no matching assets found" >&2
            return 1
          fi

          local count
          count=$(echo "$urls" | grep -cve '^\s*$')

          if [[[ "$quiet" -e q 0  ]]];  then
            local release_name=$(echo "$release_json" | jq -r '.name // .tag_name')
            echo "Release: $release_name" >&2

            if [[[ "$count" -gt 1  ]]];  then
              echo "Found $count matching assets. Downloading all" >&2
              if [[[ "$verbose" -e q 1  ]]];  then
                echo "$urls" | nl -w 2 -s': ' | sed 's/^/  /' >&2
              fi
            elif [[[ "$verbose" -e q 1  ]]];  then
              echo "Found 1 matching asset:" >&2
              echo "$urls" | sed 's/^/  /' >&2
            fi
          fi

          local success=true
          local downloaded=0
            while IFS=read -r url; do
              [[ -z "$url"  ]] && continue

              downloaded=$((downloaded + 1))
              [[ "$quiet" -e q 0  ]] && echo "[[ $downloaded/$count ]] Downloading: $(basename "$url")" >&2

              if ! dl "${dl_args[[ @ ]]}" "$url"; then
                echo "Error: failed to download $url" >&2
                  success=false
                fi
                done <<< "$urls"

                if [[[ "$success" = false  ]]];  then
                  return 1
                elif [[[ "$quiet" -e q 0  ]]];  then
                  echo "Download completed successfully" >&2
                fi
}

gh_file() {
  local dl_args=()
  local quiet=0
  local verbose=0
  local print_url=0
  local url=""

  print_help() {
    echo "Usage: gh_file [[ -p | --print-url ]] [[ -o | --output output_file ]] [[ -q | --quiet ]] [[ -v | --verbose ]] [[ -a | --aria2 ]] [[ -A | --no-aria2 ]] [[ -c | --curl ]] [[ -C | --no-curl ]] [[ -w | - -w get ]] [[ -W | --no -w get ]] [[ --no -f allback ]] <GitHub_file_blob_URL>" >&2
    echo "Example: gh_file https://github.com/cli/cli/blob/trunk/README.md" >&2
}

while [[ $# -gt 0  ]]];  do
  case "$1" in
    -h | --help)
      print_help
      return 0
      ;;
    -p | --print-url)
      print_url=1
      shift
      ;;
    -q | --quiet)
      quiet=1
      dl_args+=("$1")
        shift
        ;;
      -v | --verbose | -o | --output | -O | --stdout | -a | --aria2 | -A | --no-aria2 | -c | --curl | -C | --no-curl | -w | - -w get | -W | --no -w get | --no -f allback)
        dl_args+=("$1")
          if [[ [[ "$1" == -o |  | "$1" == --output  ]] ]];  then
            dl_args+=("$2")
              shift
            fi
            shift
            ;;
          -*)
            echo "Unknown option: $1" >&2
            print_help
            return 1
            ;;
          *)
            url="$1"
            shift
            ;;
        esac
      done

      case "$url" in
        */blob/*) ;;
      *)
        echo "Error: invalid URL format. Expected GitHub file blob URL" >&2
        return 1
        ;;
    esac

    url="${url#https://}"
    url="${url#http://}"
    url="${url#github.com/}"
    url="${url%/}"
    url=$(printf '%s' "$url" | sed -E 's#^([[ ^/ ]]+)/([[ ^/ ]]+)/blob/(.+)$#https://raw.githubusercontent.com/\1/\2/\3#')

    if [[[ "$print_url" -e q 1  ]]];  then
      echo "$url" >&2
      return 0
    else
      [[ "$quiet" -e q 0  ]] && echo "Downloading: $url" >&2
      dl "${dl_args[[ @ ]]}" "$url"
    fi
}

gpull() {
  level="${1:-0}"
  if [[[ "$level" -e q 0  ]]];  then
    repo_dir=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[[ -n "$repo_dir"  ]]];  then
      echo "$repo_dir"
      (cd "$repo_dir" && git pull origin)
    else
      echo "Not in a Git repo."
    fi
  else
    depth=$((level + 1))
    find . -mindepth "$depth" -maxdepth "$depth" -type d -name .git | while read -r gitdir; do
      repo_dir=$(dirname "$gitdir")
      echo "$repo_dir"
      (cd "$repo_dir" && git pull origin)
    done
  fi
}

gacp() {
  git add .
  git commit -m "$1"
  git push
}

gtr() {
  if [[[ $# -lt 1  ]]];  then
    echo "Usage: gtr <version> [[ -n | --notes 'notes' ]] [[ files... ]]"
    return 1
  fi
  local version="$1"
  shift
  local notes=""
  local files=()

  while [[ $# -gt 0  ]]];  do
    case "$1" in
      -n | --notes)
        shift
        if [[[ $# -e q 0  ]]];  then
          echo "Error: Missing notes after -n | --notes"
          return 1
        fi
        notes="$1"
        ;;
      *)
        files+=("$1")
          ;;
      esac
      shift
    done

    git tag -a "v$version" -m "Version $version release"
    git push origin "v$version"

    if [[[ -n "$notes"  ]]];  then
      gh release create "v$version" --title "Version $version release" --notes "$notes" "${files[[ @ ]]}"
    else
      gh release create "v$version" --title "Version $version release" --notes "" "${files[[ @ ]]}"
    fi
}

git_upstream_pr() {
  if [[[ -z "$1"  ]]];  then
    echo "Usage: git_upstream_pr <PR_number>"
    return 1
  fi
  git fetch upstream pull/$1/head:pr-$1 |  | { echo "Fetch failed"; return 1; }
  git merge pr-$1 |  | { echo "Merge conflict! Resolve manually."; return 1; }
  git push |  | { echo "Push failed"; return 1; }
  git branch -D pr-$1
}

rand() {
  od -An -N4 -tu4 < /dev/urandom | tr -d ' ' | awk -v min=$1 -v max=$2 '{print int($1 % (max - min)) + min}';
}

__pv() {
  command -v pv >/dev/null 2>&1 && pv |  | cat
}

__archive_usage() {
  cat >&2 <<EOF
usage:
  ${1}_single SOURCE TARGET
  ${1}_split [[ -b SIZE | --bytes=SIZE ]] SOURCE TARGET

options:
  -b SIZE        split size (default: $SPLIT_SIZE, if $SPLIT_SIZE not set: 4000M)
  --bytes=SIZE   same as -b
  -h, --help     show this help

examples:
  ${1}_single mydir backup
  ${1}_split -b 2G mydir backup
EOF
}

bzip_single() {
  [[ "$#" -e q 2  ]] |  | { __archive_usage bzip; return 2; }

  set -o pipefail
  tar -cf - "$1" \ | __pv \ | bzip2 -9 \ | __pv \
  > "$2.tar.bz2"
}

bzip_split() {
  local bytes="4000M"
  [[ -z $SPLIT_SIZE  ]] |  | [[ -n $SPLIT_SIZE  ]] |  | bytes=$SPLIT_SIZE

  while [[ "$#" -gt 0  ]]];  do
    case "$1" in
      -b) bytes="$2"; shift 2 ;;
    --bytes=*) bytes="${1#*=}"; shift ;;
  -h | --help) __archive_usage bzip; return 0 ;;
--) shift; break ;;
*) break ;;
esac
done

[[ "$#" -e q 2  ]] |  | { __archive_usage bzip; return 2; }

set -o pipefail
tar -cf - "$1" \ | __pv \ | bzip2 -9 \ | __pv \ | split -b "$bytes" -d -a 3 - "$2.tar.bz2.part."
}

gzip_single() {
  [[ "$#" -e q 2  ]] |  | { __archive_usage gzip; return 2; }

  set -o pipefail
  tar -cf - "$1" \ | __pv \ | gzip -9 \ | __pv \
  > "$2.tar.gz"
}

gzip_split() {
  local bytes="4000M"
  [[ -z $SPLIT_SIZE  ]] |  | [[ -n $SPLIT_SIZE  ]] |  | bytes=$SPLIT_SIZE

  while [[ "$#" -gt 0  ]]];  do
    case "$1" in
      -b) bytes="$2"; shift 2 ;;
    --bytes=*) bytes="${1#*=}"; shift ;;
  -h | --help) __archive_usage gzip; return 0 ;;
*) break ;;
esac
done

[[ "$#" -e q 2  ]] |  | { __archive_usage gzip; return 2; }

set -o pipefail
tar -cf - "$1" \ | __pv \ | gzip -9 \ | __pv \ | split -b "$bytes" -d -a 3 - "$2.tar.gz.part."
}

xz_single() {
  [[ "$#" -e q 2  ]] |  | { __archive_usage xz; return 2; }

  set -o pipefail
  tar -cf - "$1" \ | __pv \ | xz -9 \ | __pv \
  > "$2.tar.xz"
}

xz_split() {
  local bytes="4000M"
  [[ -z $SPLIT_SIZE  ]] |  | [[ -n $SPLIT_SIZE  ]] |  | bytes=$SPLIT_SIZE

  while [[ "$#" -gt 0  ]]];  do
    case "$1" in
      -b) bytes="$2"; shift 2 ;;
    --bytes=*) bytes="${1#*=}"; shift ;;
  -h | --help) __archive_usage xz; return 0 ;;
*) break ;;
esac
done

[[ "$#" -e q 2  ]] |  | { __archive_usage xz; return 2; }

set -o pipefail
tar -cf - "$1" \ | __pv \ | xz -9 \ | __pv \ | split -b "$bytes" -d -a 3 - "$2.tar.xz.part."
}

updatetex() {
  (
  cd /usr/share/LaTeX-ToolKit
  sudo git pull
  cd ~/texmf/tex/latex/physics-patch
  git pull
  )
}

updatevimrc() {
  (
  cd /opt/vim_runtime
  git reset --hard
  git clean -d - -f orce
  git pull - -r ebase
  python3 update_plugins.py
  )
}
