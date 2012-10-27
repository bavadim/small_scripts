#!/bin/bash

function getVideoUrl($url) {
    	$url =  str_replace("\/","/",$url);
    	$ch = curl_init();
    	$user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 6.0; ru; rv:1.9.2.13) ' .
    	'Gecko/20101203 Firefox/3.6.13 ( .NET CLR 3.5.30729)';
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_USERAGENT, $user_agent);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
	curl_setopt($ch, CURLOPT_VERBOSE, 1);
	$result = curl_exec($ch);
	curl_close($ch);
	$video_url = '';
	$video_array = Array();
	$hd = Array('240', '360', '480', '720', '1080');
	preg_match("/var video_host = '([0-9a-z\.\/:]*)'/", $result, $res);
	if (preg_match('/http/', $res[1]))
		$video_url.=$res[1];
	else {
		$video_url.='http://cs' . $host[1];
	}
	if (substr($video_url, strlen($video_url) - 1, 1) != '/')
		$video_url.='/';
		preg_match("/var video_uid = '(\d*)'/", $result, $res);
		$video_url.='u' . $res[1] . '/video/';
		preg_match("/var video_vtag = '([\da-zA-Z]*)'/", $result, $res);
		$video_url.=$res[1];
		preg_match("/var video_no_flv = (\d)/", $result, $res);
		if ($res[1] == 0) {
			preg_match("/http:\/\/www\.youtube\.com\/embed\/([\w\s\-]+)/", $result, $res);
			if (strlen($res[1]) == 0) {
				$video_array[] = $video_url . '.flv';
			 } else {
				$formats = array('18', '22', '37', '38');
				$ch = curl_init();
				curl_setopt($ch, CURLOPT_URL, 'http://www.youtube.com/get_video_info?video_id=' . $res[1]);
				curl_setopt($ch, CURLOPT_HEADER, 0);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
				$links = curl_exec($ch);
				curl_close($ch);
				parse_str($links, $info);
				if ($info["status"] == 'fail') {
					$video_array[] = '';
					return;
				}
				$res = explode(',', $info['url_encoded_fmt_stream_map']);
				foreach ($res as $k => $v) {
						parse_str($v, $rr);
						if (in_array($rr['itag'], $formats)) {
							$video_array[] = $rr['url'];
						}
					}
				}
			} else if ($res[1] == 0) {
				$hd = Array('240', '360', '480', '720', '1080');
				preg_match("/var video_host = '([0-9a-z\.\/:]*)'/", $result, $res);
				if (preg_match('/http/', $res[1]))
					$video_url.=$res[1];
				else {
					$video_url.='http://cs' . $res[1];
				}
				if (substr($video_url, strlen($video_url) - 1, 1) != '/')
					$video_url.='/';
					preg_match("/var video_uid = '([0-9]*)'/", $result, $res);
					$video_url.='u' . $res[1] . '/video/';
					preg_match("/var video_vtag = '([0-9a-zA-Z]*)'/", $result, $res);
					$video_url.=$res[1];
					preg_match("/var video_max_hd = '([0-9]*)'/", $result, $res);
					for ($i = 0; $i <= $res[1]; $i++)
					$video_array[] = $video_url . '.' . $hd[$i] . '.mov';
				}
				return $video_array;
}

getVideoUrl $1
