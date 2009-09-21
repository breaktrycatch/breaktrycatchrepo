/////////////////////////////////////////////////////////////////////////////
// Name:        NSNotificationCenter
// Purpose:     NSNotificationCenter classes
// Author:      Jethro Grassie
// Modified by:
// Created:     2009-2-21
// RCS-ID:      
// Copyright:   (c) CJTech Ltd
// Licence:     wxWindows licence
/////////////////////////////////////////////////////////////////////////////

package com.notifications
{

	public class NSNotificationCenter
    {
        private static var m_defaultCenter:NSNotificationCenter;
        
        public static function defaultCenter():NSNotificationCenter
        {
            if(!m_defaultCenter)
                m_defaultCenter = new NSNotificationCenter;
            return m_defaultCenter;
        }

        private var entries:Array;
        
        public function NSNotificationCenter()
        {
            entries = [];
        }
        
        public function addObserver(observer:Object, closure:Function, name:String=null, sender:Object=null):void
        {
            var entry:DispatchEntry = new DispatchEntry(observer, closure, name, sender);
            if(indexOf(entry, closure) == -1)
                entries.push(entry);
        }

        public function removeObserver(observer:Object, name:String=null, sender:Object=null):void
        {
            var entry:DispatchEntry = new DispatchEntry(observer, null, name, sender);
            var idx:int = indexOf(entry);
            while(idx != -1)
            {
                entries.splice(idx,1);
                idx = indexOf(entry);
            }
        }

        public function postNotification(notification:NSNotification):void
        {
            for(var i:uint=0; i<entries.length; i++)
            {
                var entry:DispatchEntry = entries[i];
                if(entry.name == null && entry.sender == null)
                {
                    entry.closure(notification);
                }
                else if(entry.name != null && entry.sender == null)
                {
                    if(notification.name == entry.name)
                        entry.closure(notification);
                }
                else if(entry.name == null && entry.sender != null)
                {
                    if(notification.sender == entry.sender)
                        entry.closure(notification);
                }
                else
                {
                    if(notification.name == entry.name && notification.sender == entry.sender)
                        entry.closure(notification);
                }
            }
        }

        public function postNotificationName(name:String, sender:Object=null, userInfo:Object=null):void
        {
            var note:NSNotification = new NSNotification(name, sender, userInfo);
            postNotification(note);
        }

        private function indexOf(entry:DispatchEntry, closure:Function=null):int
        {
            for(var i:uint=0; i<entries.length; i++)
            {
                if(entry.equals(entries[i], closure))
                    return i;
            }
            return -1;
        }
    }
}

class DispatchEntry
{
    public var target:Object;
    public var closure:Function;
    public var name:String;
    public var sender:Object;

    public function DispatchEntry(target:Object,closure:Function, name:String=null, sender:Object=null)
    {
        this.target = target;
        this.closure = closure;
        this.name = name;
        this.sender = sender;
    }

    public function equals(entry:DispatchEntry, closure:Function=null):Boolean
    {
        if(closure != null)
        {
            return (
                entry.target == target &&
                entry.closure == closure &&
                entry.name == name &&
                entry.sender == sender );
        }
        else
        {
            return (
                entry.target == target &&
                entry.name == name &&
                entry.sender == sender );
        }
    }
}
