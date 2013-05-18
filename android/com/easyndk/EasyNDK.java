//
//  EasyNDK.java
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//
//

package com.easyndk;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONException;
import org.json.JSONObject;

import com.easyndk.classes.AndroidNDKHelper;

import android.app.AlertDialog;
import android.os.Bundle;
import android.util.Log;
import android.widget.FrameLayout;

public class EasyNDK extends Cocos2dxActivity
{
	private FrameLayout rootView = null;
	
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
    
    private void AddButton()
    {
        Button tapButton = new Button(this);
        tapButton.setText("Tap to change text");
        tapButton.setLayoutParams(new LayoutParams(
                                                   ViewGroup.LayoutParams.WRAP_CONTENT,
                                                   ViewGroup.LayoutParams.WRAP_CONTENT)
                                  );
        
        tapButton.setOnClickListener(new OnClickListener()
        {
			@Override
			public void onClick(View v)
			{
				// TODO Auto-generated method stub
				EasyNDK.this.ChangeSomethingInCocos();
			}
		});
        
        this.GetRootView().addView(tapButton);
    }
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        AndroidNDKHelper.SetNDKReciever(this);
        this.AddButton();
    }
    
    public void ChangeSomethingInCocos()
    {
        // If you want to change anything that cocos handles, please run it on GLThread
        // Because cocos is a non threaded environment, it is required to queue stuff there
        // Every call on NDK opens up a new thread, hence making inconsistency in cocos and NDK
        
    	this.runOnGLThread(new Runnable()
                           {
			@Override
			public void run()
			{
				// TODO Auto-generated method stub
				AndroidNDKHelper.SendMessageWithParameters("ChangeLabelSelector", null);
			}
		});
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
}
