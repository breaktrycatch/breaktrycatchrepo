/////////////////////////////////////////////////////////////////////////////
// Name:        NSNotification
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

	public class NSNotification
    {
        public var name:String;
        public var sender:Object;
        public var userInfo:Object;

        public function NSNotification(name:String, sender:Object, userInfo:Object=null)
        {
            this.name = name;
            this.sender = sender;
            this.userInfo = userInfo;
        }
    }
}
