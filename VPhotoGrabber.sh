#!/bin/bash

save_folder=$1; shift;

uid=
token=

getMusicList() {
  local userid=$1; shift;
  local token=$1; shift;
  local xml=`curl -s "https://api.vk.com/method/audio.get.xml?uid=$userid&access_token=$token" | sed "s/<?xml version=\"1.0\" encoding=\"utf-8\"?>/ /g"`
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
  local uid=$1; shift;
  local access_token=$1; shift;

  local save_folder=$1; shift;
  if [[ "X$save_folder" == "X" ]] 
  then
    save_folder="./"  
  fi
  if [ ! -d "$save_folder" ]; then
    echo $save_folder
    mkdir -p $save_folder
  fi  
  pushd . > /dev/null
  cd $save_folder
  getMusicList $uid $access_token | while read line
  do
    name=${line%%,*}.mp3
    url=${line##*,}
    
    curl -s "$url" -o "$name"
  done
  popd > /dev/null
}

grab $uid $token "$save_folder"

