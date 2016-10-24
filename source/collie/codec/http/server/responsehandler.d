﻿module collie.codec.http.server.responsehandler;

import collie.codec.http.httpmessage;
import collie.codec.http.server.requesthandler;
import collie.codec.http.errocode;
import collie.codec.http.codec.wsframe;

abstract class ResponseHandler
{
	this(RequestHandler handle)
	{
		_upstream = handle;
	}

	void sendHeaders(HTTPMessage headers);

	void sendChunkHeader(size_t len);

	void sendBody(ubyte[] data);

	void sendChunkTerminator();

	void sendEOM();

protected:
	RequestHandler _upstream;
}

