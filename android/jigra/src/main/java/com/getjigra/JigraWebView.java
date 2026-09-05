package com.getjigra;

import android.content.Context;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.webkit.WebView;

public class JigraWebView extends WebView {
  private BaseInputConnection jigInputConnection;

  public JigraWebView(Context context, AttributeSet attrs) {
    super(context, attrs);
  }

  @Override
  public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
    JigConfig config = new JigConfig(getContext().getAssets(), null);
    boolean captureInput = config.getBoolean("android.captureInput", false);
    if (captureInput) {
      if (jigInputConnection == null) {
        jigInputConnection = new BaseInputConnection(this, false);
      }
      return jigInputConnection;
    }
    return super.onCreateInputConnection(outAttrs);
  }

  @Override
  public boolean dispatchKeyEvent(KeyEvent event) {
    if (event.getAction() == KeyEvent.ACTION_MULTIPLE) {
      evaluateJavascript("document.activeElement.value = document.activeElement.value + '" + event.getCharacters() + "';", null);
      return false;
    }
    return super.dispatchKeyEvent(event);
  }
}
