#!/bin/bash
lang[0]="ru-en"
lang[1]="en-ru"
#parse cmd
while getopts ":l:" opt; do
        case $opt in
        l)
                direct=$OPTARG
                shift
                ;;
        \?)
                echo "Invalid option: -$OPTARG"
                exit 1
                ;;
                
        :)
                echo "Option -$OPTARG requires an argument."
                exit 1
                ;;
        esac
        shift
done
src_txt=$1

#if no input text get it from clipboard
if [[ X$src_txt == "X" ]]
then
        src_txt=`xclip -o`
fi
request=`echo $src_txt | sed "s/ /+/g"`
#if no direct - detect
if [[ X$direct == "X" ]]
then
        lang_index=`curl -s "http://translate.yandex.net/api/v1/tr/detect" --data-urlencode "text=$request" | grep -sw -c "en"`
        direct=${lang[$lang_index]}
fi

raw_xml=`curl -s "http://translate.yandex.net/api/v1/tr/translate?lang=$direct" --data-urlencode "text=$request" | sed "s/<?xml version=\"1.0\" encoding=\"utf-8\"?>/ /g"`
xslt_xml="<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <?xml-stylesheet type=\"text/xml\" href=\"#stylesheet\"?>
        <!DOCTYPE doc [
        <!ATTLIST xsl:stylesheet
        id	ID	#REQUIRED>
        ]>
        <doc>
                <xsl:stylesheet id=\"stylesheet\" version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">
                <xsl:output method=\"text\" />
                <xsl:template match=\"xsl:stylesheet\" />
                        <xsl:template match=\"Translation\">
                                <xsl:value-of select=\"text\"/>
                        </xsl:template>
                </xsl:stylesheet>

                $raw_xml

        </doc>"
#TODO
echo $xslt_xml | xsltproc - | sed 's/+/ /g' 2>&1
echo

