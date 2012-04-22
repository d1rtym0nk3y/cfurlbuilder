component {

	variables.instance = {
		scheme = "",
		host = "",
		port = "",
		path = "",
		params = {},
		fragment = ""
	};
	
	variables.uri_pattern = createobject("java", "java.util.regex.Pattern")
								.compile("^(([^:/?##]+):)?(//([^/?##]*))?([^?##]*)(\\?([^##]*))?(##(.*))?");
	
	variables.auth_pattern = createobject("java", "java.util.regex.Pattern")
									.compile("((.*)@)?([a-zA-Z0-9\.-]*)?(:([0-9]*))?");
	
	function init() {
		return this;
	}
	
	function getInstance() {
		return instance;
	}
	
	function fromString(required string url) {
		var m = variables.uri_pattern.matcher(arguments.url);
		if(m.find()) {
			instance.scheme = isNull(m.group(2)) ? "" : m.group(2); 
			if(!isNull(m.group(4))) {
				var n = variables.auth_pattern.matcher(m.group(4));
				if(n.find()) {
					instance.userInfo = isNull(n.group(2)) ? "" : n.group(2);
					instance.host = isNull(n.group(3)) ? "" : n.group(3);
					instance.port = isNull(n.group(5)) ? "" : n.group(5); 
				}
			}
			instance.path = isNull(m.group(5)) ? "" : m.group(5);
			instance.params = isNull(m.group(7)) ? {} : decodeQueryParams(m.group(7));
			instance.fragment = isNull(m.group(9)) ? "" : m.group(9);
		}
		return this;
	}
	
	function toString(boolean urlencode=true) {
		var sb = createobject("java", "java.lang.StringBuilder");
		if(len(instance.scheme)) {
			sb.append(instance.scheme);
			sb.append(":");
		}
		if(len(instance.host)) {
			sb.append("//");
			sb.append(instance.host);
		}
		if(len(instance.port)) {
			sb.append(":");
			sb.append(instance.port);
		}
		if(len(instance.path)) {
			sb.append(instance.path);
		}
		if(!structIsEmpty(instance.params)) {
			sb.append("?");
			sb.append(encodeQueryParams(urlencode));
		}
		if(len(instance.fragment)) {
			sb.append(chr(35)); // hash char
            sb.append(instance.fragment);			
		}
		return sb.toString();
	}
	
	function withScheme(required string scheme) {
		instance.scheme = arguments.scheme;
		return this;
	}
	
	function withHost(required string host) {
		instance.host = arguments.host;
		return this;
	}

	function withPort(required numeric port) {
		instance.port = arguments.port;
		return this;
	}
	
	function withPath(required string path) {
		instance.path = arguments.path;
		return this; 
	}
	
	function withQuery(required string query) {
		instance.params = decodeQueryParams(arguments.query);
		return this;
	}
	
	function withFragment(required string fragment) {
		instance.fragment = arguments.fragment;
		return this;
	}

	function addParam(required string name, required string value) {
		if(!structKeyExists(instance.params, arguments.name)) instance.params[arguments.name] = [];
		arrayAppend(instance.params[arguments.name], arguments.value);
		return this;
	}
	function setParam(required string name, required string value) {
		instance.params[arguments.name] = [arguments.value];
		return this;
	}
	function removeParam(required string name) {
		structDelete(instance.params, arguments.name);
		return this;
	}

	private function decodeQueryParams(required string qs) {
		var params = {};
		qs = listlast(qs, "?");
		for(var pair in listToArray(qs, "&")) {
			var key = urlDecode(listFirst(pair, "="));
			var val = javacast("null", 0);
			if(listLen(pair, "=") == 2) {
				val = urlDecode(listLast(pair, "="));
			}
			if(!structKeyExists(params, key)) params[key] = [];
			arrayAppend(params[key], val);
		}
		return params;
	}		

	private function encodeQueryParams(boolean urlencode=true) {
		var sb = createobject("java", "java.lang.StringBuilder");
		for(var key in instance.params) {
			for(var val in instance.params[key]) {
				sb.append(urlencode ? urlEncodedFormat(key) : key);
				if(!isNull(val)) {
					sb.append("=");
					sb.append(urlencode ? urlEncodedFormat(val) : val);
				}
				sb.append('&');
			}	
		}
		sb.deleteCharAt(sb.length() - 1);
        return sb.toString();		
	}
	


}
