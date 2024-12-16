#!/bin/sh

calc_percentage() {
  echo "$(($(("$1" / 100)) * "$2"))"
}

help() {
  cat << EOT
Usage: resizeGif.sh <input-file> [OPTIONS]

you can provide --percentage or --coarse-in to decide how to resize the gif

Options:
  -p --percentage    <number>         size percentage to resize the image to
  -c --coarse-in     <x_res>x<y_res>  maximum resolution to box the output image in
  -o --out           <filename>       name of the output file
EOT
}

if [ -z "$1" ]; then
  help
  exit 1
fi

IN_FILE="$1"
shift

while [ -n "$1" ]; do
  case "$1" in
    -p|--percentage)
      shift
      PERCENTAGE="$1"
      ;;
    -c|--coarse-in)
      shift
      COARSE_IN="$1"
      ;;
    -o|--out)
      shift
      OUT_FILE="$1"
      ;;
  esac
  shift
done

[ -n "$PERCENTAGE" ] && [ -n "$COARSE_IN" ] && {
  echo "You may only provide percentage OR coarse-in"
  exit 1
}



base_resolution=$(identify "$IN_FILE" | awk 'NR==1{print $3}')
x_res="$(echo "$base_resolution" | sed 's/\(.*\)x\(.*\)/\1/g')"
y_res="$(echo "$base_resolution" | sed 's/\(.*\)x\(.*\)/\2/g')"


if [ -n "$PERCENTAGE" ]; then
  x_scaled="$(calc_percentage "$x_res" "$PERCENTAGE")"
  y_scaled="$(calc_percentage "$y_res" "$PERCENTAGE")"
elif [ -n "$COARSE_IN" ]; then
  arg_x="$(echo "$COARSE_IN" | sed 's/\(.*\)x\(.*\)/\1/g')"
  arg_y="$(echo "$COARSE_IN" | sed 's/\(.*\)x\(.*\)/\2/g')"
  x_fact="$(( $((arg_x * 100)) / x_res))"
  y_fact="$(( $((arg_y * 100)) / y_res))"
  if [ "$x_fact" -lt "$y_fact" ]; then
    lower_fact="$x_fact"
  else
    lower_fact="$y_fact"
  fi

  x_scaled="$(calc_percentage "$x_res" "$lower_fact")"
  y_scaled="$(calc_percentage "$y_res" "$lower_fact")"
else
  echo "You need to give --percentage or --coarse-in."
  exit 1
fi

if [ -z "$OUT_FILE" ]; then
  OUT_FILE="smaller_${IN_FILE}"
fi

echo "resizing to ${x_scaled}x${y_scaled}"

convert "$IN_FILE" -coalesce -resize "${x_scaled}x${y_scaled}" -fuzz 2% +dither -layers Optimize +map "$OUT_FILE"
