package com.valkryie.view {
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.ScaleImage;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.DiscSectorZone;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jkeon
	 */
	public class ParticlesView extends BaseView {
		
		
		protected var __renderer:BitmapRenderer;
		
		protected var __smoke:Emitter2D;
		
		
		public function ParticlesView() {
			super();
			linkage = "View_Particles";
		}

		override protected function onAdded() : void {
			super.onAdded();
			init();
		}
		
		protected function init():void {
			
			
			__renderer = new BitmapRenderer(new Rectangle(0,0,760,760));
			
			__smoke = new Emitter2D();

			__smoke.counter = new Blast(10);
			__smoke.addInitializer(new Lifetime(3,4));
			__smoke.addInitializer( new Velocity( new DiscSectorZone( new Point( 0, 0 ), 40, 30, -4 * Math.PI / 7, -3 * Math.PI / 7 ) ) );
			__smoke.addInitializer( new SharedImage( new RadialDot( 2, 0xFF0000 ) ) );
			
			__smoke.addAction( new Age( ) );
			__smoke.addAction( new Move( ) );
			__smoke.addAction( new LinearDrag( 0.01 ) );
			__smoke.addAction( new ScaleImage( 1, 15 ) );
			__smoke.addAction( new Fade( 0.15, 0 ) );
			__smoke.addAction( new RandomDrift( 15, 15 ) );
			
			__smoke.x = 265;
			__smoke.y = 345;
			__smoke.start( );
			
			
			__renderer.addEmitter(__smoke);
			
			this.addChild(__renderer);
		}
	}
}
