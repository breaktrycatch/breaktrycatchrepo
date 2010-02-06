package com.breaktrycatch.needmorehumans.control.physics;

import org.jbox2d.collision.ContactID;
import org.jbox2d.dynamics.ContactListener;
import org.jbox2d.dynamics.contacts.ContactPoint;
import org.jbox2d.dynamics.contacts.ContactResult;

import com.breaktrycatch.needmorehumans.utils.LogRepository;

public class HumanContactListener implements ContactListener {

	private PhysicsWorldWrapper _reportTo;
	
	
	public HumanContactListener(PhysicsWorldWrapper reportTo)
	{
		_reportTo = reportTo;
	}
	
	
	@Override
	public void add(ContactPoint point) 
	{
		if(point.shape1.getBody().getUserData() instanceof PhysicsUserDataVO && point.shape2.getBody().getUserData() instanceof PhysicsUserDataVO)
		{
			PhysicsUserDataVO data1 = (PhysicsUserDataVO)point.shape1.getBody().getUserData();
			PhysicsUserDataVO data2 = (PhysicsUserDataVO)point.shape2.getBody().getUserData();

//			if(sprite1 != null && sprite2 != null && sprite1.isHuman && sprite2.isHuman && (point.shape1.getUserData() == null || point.shape2.getUserData() == null))
			if(data1 != null && data2 != null)
			{
				//report only sprites which have user data, are human and involve a collision with the last dropped human
				if(data1.isHuman && data2.isHuman && (point.shape1.getBody() == _reportTo.getActiveHuman() || point.shape2.getBody() == _reportTo.getActiveHuman()))
				{
					LogRepository.getInstance().getMikesLogger().info("WE HAVE HUMAN CONTACT!");
					_reportTo.reportHumanHumanContact(cloneContactPoint(point));
				}
				else if((data1.isHuman || data2.isHuman) && (data1.breaksHumanJoints || data2.breaksHumanJoints))
				{
					_reportTo.reportHumanBreakerContact(cloneContactPoint(point));
				}
			}
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

	// ------- HELPERS ----------------//
	private final ContactPoint cloneContactPoint(ContactPoint orig)
	{
		ContactPoint clone = new ContactPoint();
		clone.shape1 = orig.shape1;
		clone.shape2 = orig.shape2;
		clone.position = orig.position.clone();
		clone.normal = orig.normal.clone();
		clone.id = new ContactID(orig.id);
		clone.velocity = orig.velocity.clone();
		
		return clone;
	}
}
