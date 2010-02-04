package com.breaktrycatch.needmorehumans.control.physics;

import org.jbox2d.collision.ContactID;
import org.jbox2d.dynamics.ContactListener;
import org.jbox2d.dynamics.contacts.ContactPoint;
import org.jbox2d.dynamics.contacts.ContactResult;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class HumanContactListener implements ContactListener {

	private PhysicsWorldWrapper _reportTo;
	
	public HumanContactListener(PhysicsWorldWrapper reportTo)
	{
		_reportTo = reportTo;
	}
	
	@Override
	public void add(ContactPoint point) {
		DisplayObject sprite1 = (DisplayObject)point.shape1.getBody().getUserData();
		DisplayObject sprite2 = (DisplayObject)point.shape2.getBody().getUserData();
//		LogRepository.getInstance().getMikesLogger().info("CONTACT!");
		
//		if(sprite1 != null && sprite2 != null && (sprite1.isHuman || sprite2.isHuman))
//		{
//			LogRepository.getInstance().getMikesLogger().info("WE HAVE ONE HUMAN CONTACT!");
//		}
		if(sprite1 != null && sprite2 != null && sprite1.isHuman && sprite2.isHuman)
		{
			LogRepository.getInstance().getMikesLogger().info("WE HAVE HUMAN CONTACT!");
			ContactPoint cp = new ContactPoint();
			cp.shape1 = point.shape1;
			cp.shape2 = point.shape2;
			cp.position = point.position.clone();
			cp.normal = point.normal.clone();
			cp.id = new ContactID(point.id);
			cp.velocity = point.velocity.clone();
			
			_reportTo.reportHumanContact(cp);
		}
	}

	@Override
	public void persist(ContactPoint point) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void remove(ContactPoint point) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void result(ContactResult point) {
		// TODO Auto-generated method stub
		
	}


	

}
