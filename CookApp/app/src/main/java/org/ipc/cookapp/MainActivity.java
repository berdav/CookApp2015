package org.ipc.cookapp;

import android.app.Activity;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.RelativeLayout;

public class MainActivity extends Activity {
    private View hiddenPanel;
    private View button_search;
    private View button_close;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        hiddenPanel = findViewById(R.id.hidden_panel);
        button_search=findViewById(R.id.searchbutton);
        ((FloatingActionButton) button_search).setImageDrawable(getDrawable(R.drawable.abc_ic_search_api_mtrl_alpha));
        //button_close=findViewById(R.id.buttonclosewrapper);
    }

    public void slideUpDown(final View view) {
        if (!isPanelShown()) {
            // Show the panel
            Animation bottomUp = AnimationUtils.loadAnimation(this,
                    R.anim.bottom_up);

            hiddenPanel.startAnimation(bottomUp);
            hiddenPanel.setVisibility(View.VISIBLE);
            ((FloatingActionButton) button_search).setImageDrawable(getDrawable(R.drawable.abc_ic_clear_mtrl_alpha));
            //button_search.setVisibility(View.VISIBLE);
            //button_close.setVisibility(View.GONE);
        }
        else {
            // Hide the Panel
            Animation bottomDown = AnimationUtils.loadAnimation(this,
                    R.anim.bottom_down);

            hiddenPanel.startAnimation(bottomDown);
            hiddenPanel.setVisibility(View.GONE);
            ((FloatingActionButton) button_search).setImageDrawable(getDrawable(R.drawable.abc_ic_search_api_mtrl_alpha));
            //button_close.setVisibility(View.VISIBLE);
        }
    }

    private boolean isPanelShown() {
        return hiddenPanel.getVisibility() == View.VISIBLE;
    }

    @Override
    public void onBackPressed() {
        if (isPanelShown()) {
            slideUpDown(hiddenPanel);
            return;
        }

        // Otherwise defer to system default behavior.
        super.onBackPressed();
    }

}
