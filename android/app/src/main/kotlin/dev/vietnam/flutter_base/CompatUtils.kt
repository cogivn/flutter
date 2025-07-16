package dev.vietnam.flutter_base

import android.content.Context
import android.content.res.Resources
import androidx.annotation.IntDef
import dev.vietnam.flutter_base.CompatUtils.NAVIGATION_BAR_INTERACTION_MODE_GESTURE

object CompatUtils {

    @Retention(AnnotationRetention.SOURCE)
    @IntDef(
        NAVIGATION_BAR_INTERACTION_MODE_THREE_BUTTON,
        NAVIGATION_BAR_INTERACTION_MODE_TWO_BUTTON,
        NAVIGATION_BAR_INTERACTION_MODE_GESTURE
    )
    annotation class NavigationBarInteractionMode

    /**
     * Classic three-button navigation (Back, Home, Recent Apps)
     */
    const val NAVIGATION_BAR_INTERACTION_MODE_THREE_BUTTON = 0

    /**
     * Two-button navigation (Android P navigation mode: Back, combined Home and Recent Apps)
     */
    const val NAVIGATION_BAR_INTERACTION_MODE_TWO_BUTTON = 1

    /**
     * Full screen gesture mode (introduced with Android Q)
     */
    const val NAVIGATION_BAR_INTERACTION_MODE_GESTURE = 2

    /**
     * Returns the interaction mode of the system navigation bar.
     *
     * @param context The [Context] that is used to read the resource configuration.
     * @return the [NavigationBarInteractionMode]
     */
    @NavigationBarInteractionMode
    fun getNavigationBarInteractionMode(context: Context): Int {
        val resources: Resources = context.resources
        val resourceId = resources.getIdentifier("config_navBarInteractionMode", "integer", "android")
        return if (resourceId > 0) resources.getInteger(resourceId) else NAVIGATION_BAR_INTERACTION_MODE_THREE_BUTTON
    }
}

inline fun Context.ifGestureMode(block: () -> Unit) {
    if (CompatUtils.getNavigationBarInteractionMode(this) == NAVIGATION_BAR_INTERACTION_MODE_GESTURE) {
        block()
    }
}