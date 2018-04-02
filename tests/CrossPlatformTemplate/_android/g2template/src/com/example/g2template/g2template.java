package com.example.g2template;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.opengles.GL10;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.view.MotionEvent;

public class g2template extends Activity
{
	public int AM_CONNECT = 0;
	public int AM_INIT = 1;
	public int AM_QUIT = 2;
	public int AM_RESIZE = 3;
	public int AM_DRAW = 4;
	public int AM_TOUCH_DOWN = 5;
	public int AM_TOUCH_UP = 6;
	public int AM_TOUCH_MOVE = 7;
	public G2MPView GLView;
	public AssetManager AssetMgr;
	public FileManager FileMgr;
	private InputStream AssetStream = null;
	private Bitmap FontBitmap;
	private int FontWidth;
	private int FontHeight;
	private boolean CanDraw;
	private boolean Closing;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        CanDraw = false;
        Closing = false;
        AssetMgr = getAssets();
        FileMgr = new FileManager();
        GLView = new G2MPView(getApplication().getApplicationContext());
    	setContentView(GLView);
    	GLView.setKeepScreenOn(true);
    	setTitle("G2MP");
    }
    @Override
    public void onDestroy () {
    	Closing = true;
    	while (CanDraw) ;
    	super.onDestroy();
    }
    @Override
    public void onStop () {
    	if (!Closing) {Closing = true; while (CanDraw); finish();}
    	else while (CanDraw);
    	super.onStop();
    }
    @Override
    public void onPause () {
    	if (!Closing) {Closing = true; while (CanDraw); finish();}
    	else while (CanDraw);
    	super.onPause();
    	GLView.onPause();
    }
    @Override
    public void onResume () {
    	super.onResume();
    	GLView.onResume();
    }
    public void FinalizeJNI () {
    	MessageJNI(AM_QUIT, 0, 0, 0);
    	CanDraw = false;
    }
    public void appclose () {
    	if (!Closing) {Closing = true; CanDraw = false; finish();}
    }
    public int fopeninput (String f) {
    	return FileMgr.FOpenInput(f);
    }
    public void fopenoutput (String f) {
    	FileMgr.FOpenOutput(f);
    }
    public void fsetpos (int pos) {
    	FileMgr.SetPos(pos);
    }
    public void fclose () {
    	FileMgr.FClose();
    }
    public int fread (byte[] buffer, int offset, int len) {
    	return FileMgr.Read(buffer, offset, len);
    }
    public void fwrite (byte[] buffer, int offset, int len) {
    	FileMgr.Write(buffer, offset, len);
    }
    public boolean fexists (String f) {
    	File file = GLView.getContext().getFileStreamPath(f);
    	return file.exists();
    }
    public int faopen (String f) {
    	int StreamSize = 0;
    	try {
			AssetStream = AssetMgr.open(f, 1);
			StreamSize = AssetStream.available();
			AssetStream.mark(StreamSize);
		} 
		catch (IOException e) {}
		return StreamSize;
	}
    public void fasetpos (int pos) {
    	try {
	    	AssetStream.reset();
	    	AssetStream.skip(pos);
    	} 
		catch (IOException e) {}
    }
    public void faclose () {
		if (AssetStream != null) {
			try {AssetStream.close();}
			catch (IOException e) {} 
			AssetStream = null;
		}
	}
    public int faread (byte[] buffer, int offset, int len) {
		int BytesRead = 0;
    	try {
    		BytesRead = AssetStream.read(buffer, offset, len);
    	}
		catch (IOException e) {};
		return BytesRead;
	}
    public int fontgetw () {
    	return FontWidth;
    }
    public int fontgeth () {
    	return FontHeight;
    }
    public int fontgetd (int[] buffer) {
    	FontBitmap.getPixels(buffer, 0, FontWidth, 0, 0, FontWidth, FontHeight);
    	return buffer.length;
    }
    public void fontmake (int size, int[] CharWidths, int[] CharHeights) {
    	Paint p = new Paint();
    	p.setColor(Color.WHITE);
    	p.setTextSize(size);
    	p.setFlags(Paint.ANTI_ALIAS_FLAG);
    	int MaxCharWidth = 0;
    	int MaxCharHeight = 0;
    	Rect Bounds = new Rect();
    	for (int i = 0; i < 256; i++) {
    		p.getTextBounds(Character.toChars(i), 0, 1, Bounds);
    		int w = Bounds.right - Bounds.left + 1;
    		int h = Bounds.bottom - Bounds.top + 1;
    		CharWidths[i] = w; CharHeights[i] = h;
    		if (MaxCharWidth < w) MaxCharWidth = w;
    		if (MaxCharHeight < h) MaxCharHeight = h;
    	}
    	int BmpWidth = MaxCharWidth * 16;
    	int BmpHeight = MaxCharHeight * 16;
    	int Width = 1; while (Width < BmpWidth) Width = Width << 1;
    	int Height = 1; while (Height < BmpHeight) Height = Height << 1;
    	FontWidth = Width; FontHeight = Height;
    	FontBitmap = Bitmap.createBitmap(Width, Height, Bitmap.Config.ARGB_4444);
    	Canvas c = new Canvas(FontBitmap);
    	Paint p1 = new Paint();
    	p1.setColor(Color.BLACK);
    	c.drawRect(0, 0, Width, Height, p1);
    	int CharWidth = Width / 16;
    	int CharHeight = Height / 16;
    	for (int i = 0; i < 256; i++) {
    		CharHeights[i] = MaxCharHeight;
    		int x = i % 16;
    		int y = i / 16;
    		int w = CharWidths[i];
    		int h = CharHeights[i];
    		c.drawText(
    			Character.toChars(i), 0, 1, 
    			x * CharWidth + (CharWidth - w) * 0.5f, 
    			y * CharHeight + CharHeight - (CharHeight - h) * 0.5f,
    			p
    		);
    	}
    }
    public class FileManager {
    	public int FM_STATE_IDLE = 0;
    	public int FM_STATE_READ = 1;
    	public int FM_STATE_WRITE = 2;
    	private FileOutputStream fos;
    	private FileInputStream fis;
    	private int State = FM_STATE_IDLE;
    	public int FOpenInput(String FileName) {
    		int FSize = 0;
    		try {
    			fis = openFileInput(FileName);
    			FSize = fis.available();
    			fis.mark(FSize);
    		}
    		catch (IOException e) {};
    		State = FM_STATE_READ;
    		return FSize;
    	}
    	public void FOpenOutput(String FileName) {
    		try {fos = openFileOutput(FileName, Context.MODE_PRIVATE);}
    		catch (IOException e) {};
    		State = FM_STATE_WRITE;
    	}
    	public void FClose() {
    		if (State == FM_STATE_READ) {
    			try {fis.close();}
    			catch (IOException e) {};
    		} else if (State == FM_STATE_WRITE) {
    			try {fos.close();}
    			catch (IOException e) {};
    		}
    		State = FM_STATE_IDLE;
    	}
    	public int Read(byte[] buffer, int offset, int len) {
    		int BytesRead = 0;
    		try {BytesRead = fis.read(buffer, offset, len);}
    		catch (IOException e) {};
    		return BytesRead;
    	}
    	public void Write(byte[] buffer, int offset, int len) {
    		try {fos.write(buffer, offset, len);}
    		catch (IOException e) {};
    	}
    	public void SetPos(int Pos) {
    		try {
    	    	fis.reset();
    	    	fis.skip(Pos);
        	} 
    		catch (IOException e) {}
    	}
    }
    class G2MPView extends GLSurfaceView {
        public G2MPView(Context context) {
            super(context);
            Init(false, 0, 0);
        }
        public G2MPView(Context context, boolean translucent, int depth, int stencil) {
            super(context);
            Init(translucent, depth, stencil);
        }
        private void Init(boolean translucent, int depth, int stencil) {
            if (translucent) {
                this.getHolder().setFormat(PixelFormat.TRANSLUCENT);
            }
            setEGLContextFactory(new ContextFactory());
            setEGLConfigChooser(
            	translucent ?
            	new ConfigChooser(8, 8, 8, 8, depth, stencil) :
            	new ConfigChooser(5, 6, 5, 0, depth, stencil) 
            );
            setRenderer(new Renderer());
        }
        @Override
        public boolean onTouchEvent(final MotionEvent event) {
        	int Action = event.getAction();
        	boolean Result = false;
        	switch (Action) {
        		case MotionEvent.ACTION_DOWN:
        			MessageJNI(AM_TOUCH_DOWN, Math.round(event.getX()), Math.round(event.getY()), 0);
        			Result = true;
        		break;
        		case MotionEvent.ACTION_MOVE:
        			MessageJNI(AM_TOUCH_MOVE, Math.round(event.getX()), Math.round(event.getY()), 0);
        			Result = true;
        		break;
        		case MotionEvent.ACTION_UP:
        			MessageJNI(AM_TOUCH_UP, Math.round(event.getX()), Math.round(event.getY()), 0);
        			Result = true;
        		break;
        	}
        	return Result;
        }
        private class ContextFactory implements GLSurfaceView.EGLContextFactory {
            private int EGL_CONTEXT_CLIENT_VERSION = 0x3098;
            public EGLContext createContext(EGL10 egl, EGLDisplay display, EGLConfig eglConfig) {
                int[] attrib_list = {EGL_CONTEXT_CLIENT_VERSION, 1, EGL10.EGL_NONE };
                EGLContext context = egl.eglCreateContext(display, eglConfig, EGL10.EGL_NO_CONTEXT, attrib_list);
                return context;
            }

            public void destroyContext(EGL10 egl, EGLDisplay display, EGLContext context) {
                egl.eglDestroyContext(display, context);
            }
        }
        private class ConfigChooser implements GLSurfaceView.EGLConfigChooser {
        	protected int mRedSize;
            protected int mGreenSize;
            protected int mBlueSize;
            protected int mAlphaSize;
            protected int mDepthSize;
            protected int mStencilSize;
            private int[] mValue = new int[1];
            public ConfigChooser(int r, int g, int b, int a, int depth, int stencil) {
                mRedSize = r;
                mGreenSize = g;
                mBlueSize = b;
                mAlphaSize = a;
                mDepthSize = depth;
                mStencilSize = stencil;
            }
            private int EGL_OPENGL_ES_BIT = 0x01;
            //private int EGL_OPENGL_ES2_BIT = 4;
            private int[] s_configAttribs2 = {
                EGL10.EGL_RED_SIZE, 4,
                EGL10.EGL_GREEN_SIZE, 4,
                EGL10.EGL_BLUE_SIZE, 4,
                EGL10.EGL_RENDERABLE_TYPE, EGL_OPENGL_ES_BIT,
                EGL10.EGL_NONE
            };
            public EGLConfig chooseConfig(EGL10 egl, EGLDisplay display) {
                int[] num_config = new int[1];
                egl.eglChooseConfig(display, s_configAttribs2, null, 0, num_config);
                int numConfigs = num_config[0];
                if (numConfigs <= 0) {
                    throw new IllegalArgumentException("No configs match configSpec");
                }
                EGLConfig[] configs = new EGLConfig[numConfigs];
                egl.eglChooseConfig(display, s_configAttribs2, configs, numConfigs, num_config);
                return chooseConfig(egl, display, configs);
            }
            public EGLConfig chooseConfig(EGL10 egl, EGLDisplay display, EGLConfig[] configs) {
                for (EGLConfig config : configs) {
                    int d = findConfigAttrib(egl, display, config, EGL10.EGL_DEPTH_SIZE, 0);
                    int s = findConfigAttrib(egl, display, config, EGL10.EGL_STENCIL_SIZE, 0);
                    if (d < mDepthSize || s < mStencilSize) continue;
                    int r = findConfigAttrib(egl, display, config, EGL10.EGL_RED_SIZE, 0);
                    int g = findConfigAttrib(egl, display, config, EGL10.EGL_GREEN_SIZE, 0);
                    int b = findConfigAttrib(egl, display, config, EGL10.EGL_BLUE_SIZE, 0);
                    int a = findConfigAttrib(egl, display, config, EGL10.EGL_ALPHA_SIZE, 0);
                    if (r == mRedSize && g == mGreenSize && b == mBlueSize && a == mAlphaSize) return config;
                }
                return null;
            }
            private int findConfigAttrib(EGL10 egl, EGLDisplay display, EGLConfig config, int attribute, int defaultValue) {
                if (egl.eglGetConfigAttrib(display, config, attribute, mValue)) {
                    return mValue[0];
                }
                return defaultValue;
            }
        }
        private class Renderer implements GLSurfaceView.Renderer {
            public void onDrawFrame(GL10 gl) {
            	if (Closing && CanDraw) {
            		FinalizeJNI();
            	}
            	if (CanDraw)
            	MessageJNI(AM_DRAW, 0, 0, 0);
            }
            public void onSurfaceChanged(GL10 gl, int width, int height) {
            	if (!CanDraw) {
            		MessageJNI(AM_CONNECT, 0, 0, 0);
            		MessageJNI(AM_INIT, width, height, 0);
                	CanDraw = true;
            	}
            	MessageJNI(AM_RESIZE, width, height, 0);	
            }
            public void onSurfaceCreated(GL10 gl, EGLConfig config) {

            }
        }
    }
    public native void MessageJNI(int MessageType, int Param0, int Param1, int Param2);
    static {
    	System.loadLibrary("openal");
        System.loadLibrary("g2mp");
    }
}
