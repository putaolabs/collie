﻿module collie.socket.eventloopgroup;

import core.thread;
import std.parallelism;
import std.container.array;

import collie.socket.eventloop;
import collie.socket.common;
import collie.utils.functional;



class EventLoopGroup
{
	this(uint size = (totalCPUs - 1),int waitTime = 2000)
	{
            foreach(i;0..size){
                auto loop = new EventGroupLoop(new EventLoop);
                loop.waiteTime = waitTime;
                _loops[loop] = new Thread(&loop.start);
            }
	}
	
	void start()
	{
            foreach( ref t; _loops.values ){
                t.start();
            }
            _started = true;
	}
	
	void stop()
	{
            foreach( ref loop; _loops.keys ){
                loop.stop();
            }
            _started = false;
            wait();
	}

	@property length(){ return _loops.length;}
	
	void addEventLoop(EventLoop lop,int waitTime = 2000)
	{
            auto loop = new EventGroupLoop(lop);
            loop.waiteTime = waitTime;
            auto th = new Thread(&loop.start);
            _loops[loop] = th;
            if(_started)
                th.start();
	}
	
	void post(uint index, CallBack cback)
	{
            at(index).post(cback);
	}
	
	EventLoop opIndex(size_t index)
	{
           return at(index);
	}
	
	EventLoop at(size_t index)
	{
            auto loops =  _loops.keys ;
            auto i = index  % cast(size_t)loops.length;
            return loops[i].eventLoop;
	}
	
	void wait()
	{
            foreach( ref t; _loops.values ){
                t.join(false);
            }
	}
    
private :
	bool _started; 
	Thread[EventGroupLoop] _loops;
}


private:

class EventGroupLoop
{
    this(EventLoop loop)
    {
        _loop = loop;
    }
    
    void start()
    {
        _loop.run();
    }
    
    alias eventLoop this;
    
    @property eventLoop(){return _loop;}
    
    @property waitTime() {return _waitTime;}
    
    @property waiteTime(int time){_waitTime = time;}
private:
    EventLoop _loop;
    int _waitTime = 5000;
}
