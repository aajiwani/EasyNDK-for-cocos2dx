package com.easyndk;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONException;
import org.json.JSONObject;

import com.easyndk.classes.AndroidNDKHelper;

import android.app.AlertDialog;
import android.os.Bundle;
import android.util.Log;
import android.widget.FrameLayout;

import com.chartboost.sdk.*;

public class EasyNDK extends Cocos2dxActivity
{
	private FrameLayout rootView = null;
	private Chartboost cb;
	
	/* Helper method to get the hold of Cocos2dx Changable View,
	 * You can add others views using this view
	 */
	private FrameLayout GetRootView()
	{
		if (this.rootView == null)
		{
			this.rootView = (FrameLayout)this.getWindow().getDecorView().findViewById(android.R.id.content);
		}
		return this.rootView;
	}
	
	static
	{
        System.loadLibrary("game");
   }
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        AndroidNDKHelper.SetNDKReciever(this);
        
        // Configure chartboost
        this.cb = Chartboost.sharedChartboost();
        
        String appId = "Your-App-Id";
        String appSignature = "Your-App-Signature";
        
        this.cb.onCreate(this, appId, appSignature, null);
        
        // Notify the beginning of a user session
        this.cb.startSession();
    }
    
    public void LoadInterstitial(JSONObject prms)
    {
    	// Show an interstitial
        this.cb.showInterstitial();
    }
    
    public void SampleSelector(JSONObject prms)
    {
    	Log.v("SampleSelector", "purchase something called");
    	Log.v("SampleSelector", "Passed params are : " + prms.toString());
    	
    	String CPPFunctionToBeCalled = null;
		try
		{
			CPPFunctionToBeCalled = prms.getString("to_be_called");
		}
		catch (JSONException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage("This is a sample popup on Android").
        setTitle("Hello World!").
        setNeutralButton("OK", null).show();
    	
    	AndroidNDKHelper.SendMessageWithParameters(CPPFunctionToBeCalled, null);
    }
    
    @Override
    protected void onStart()
    {
        super.onStart();
        this.cb.onStart(this);
    }

    @Override
    protected void onStop()
    {
        super.onStop();
        this.cb.onStop(this);
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();
        this.cb.onDestroy(this);
    }

    @Override
    public void onBackPressed()
    {
        // If an interstitial is on screen, close it. Otherwise continue as normal.
        if (this.cb.onBackPressed())
            return;
        else
            super.onBackPressed();
    }
}
