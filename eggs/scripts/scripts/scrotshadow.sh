#!/bin/bash
# NAME:         dropshadow.sh
# VERSION:      
# AUTHOR:       (c) 2013 Glutanimate
# DESCRIPTION:  - adds transparent dropshadow to images (e.g. screenshots)
#               - moves them to predefined screenshot folder
# FEATURES:     
# DEPENDENCIES: imagemagick suite
#
# LICENSE:      MIT license (http://opensource.org/licenses/MIT)
#
# NOTICE:       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#               INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#               PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#               LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
#               TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
#               OR OTHER DEALINGS IN THE SOFTWARE.
#
#
# USAGE:        dropshadow.sh <image>

SCREENSHOTFOLDER="$HOME/Pictures/Screenshots"


FILE="${1}"
FILENAME="${FILE##*/}"
FILEBASE="${FILENAME%.*}"

convert "${FILE}" \( +clone -background black -shadow 80x20+0+15 \) +swap -background transparent -layers merge +repage "$SCREENSHOTFOLDER/${FILEBASE}.png"

rm "$FILE" #remove this line to preserve original image
