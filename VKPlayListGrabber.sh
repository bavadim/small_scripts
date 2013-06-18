#!/bin/bash

save_folder=$1; shift;

token=

getMusicList() {
  local token="$1"; shift;
  local xml=`curl -s "https://api.vk.com/method/audio.get.xml?access_token=$token" | sed "s/<?xml version=\"1.0\" encoding=\"utf-8\"?>/ /g"` 2>&1
  local xslt_xml="<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <?xml-stylesheet type=\"text/xml\" href=\"#stylesheet\"?>
        <!DOCTYPE doc [
        <!ATTLIST xsl:stylesheet
        id      ID      #REQUIRED>
        ]>
        <doc>
                <xsl:stylesheet id=\"stylesheet\" version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">
                  <xsl:output method=\"text\" />

                  <xsl:template match=\"/\">
                    <xsl:for-each select=\"doc/response/audio\"> 
                      <xsl:value-of select=\"artist\"/> - <xsl:value-of select=\"title\"/>,<xsl:value-of select=\"url\"/> 
                      <xsl:text>&#10;</xsl:text>
                    </xsl:for-each>
                  </xsl:template>
                </xsl:stylesheet>

                $xml

        </doc>"
  echo $xslt_xml | xsltproc -
}

grab() {
  local access_token=$1; shift;

  local save_folder=$1; shift;
  if [[ "X$save_folder" == "X" ]] 
  then
    save_folder="./"  
  fi
  if [ ! -d "$save_folder" ]; then
    mkdir -p $save_folder
  fi  
  pushd . > /dev/null
  cd $save_folder
  getMusicList $uid $access_token | while read line
  do
    name=${line%%,*}.mp3
    url=${line##*,}
    
    echo "Загрузка ${name}..."
    curl -s "$url" -o "$name" 2>&1
    sleep 0.4s

    if [[ $(du -s "${name}" | cut -f1) -le 1024  ]];
    then
      echo "Файл "${name}" возможно не скачался"
    fi
  done
  popd > /dev/null
}

grab "$token" "$save_folder"

