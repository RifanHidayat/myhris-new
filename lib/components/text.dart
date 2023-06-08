import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/utils/constans.dart';


class TextApp {
  static Widget label(
      {required text,
      size,
      color,
      weigh,
      family,
      decoration,
      align,
      letterSpacing,
      height,onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        textAlign: align ?? TextAlign.left,
        style: TextStyle(
          color: color??Constanst.colorBlack,
          decoration: decoration ?? TextDecoration.none,
          fontSize: size ?? 12,
          fontWeight: weigh ?? FontWeight.w500,
          height: height ?? 1.2,
          letterSpacing: letterSpacing ?? 0.5,
        ),
      ),
    );
  }

  static Widget TextGroupColumn({title,
      subtitle,
      subtitleBold,
      isDropdown,
      onTapClear,
      titleBold}){
        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextApp.label(  text: title,
          weigh: titleBold == true ? FontWeight.bold : FontWeight.w400,
          size: 14.0,),
        SizedBox(
          height: 5,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 90,
                child: TextApp.label(   text: subtitle,
                  weigh:
                      subtitleBold == true ? FontWeight.bold : FontWeight.w400,
                  size: 13.0,),
              ),
              isDropdown == true
                  ? Expanded(
                      flex: 20,
                      child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              onTapClear != null
                                  ? InkWell(
                                      onTap: onTapClear,
                                      child: Icon(
                                        Iconsax.close_circle,
                                        color:Constanst.colorPrimary,
                                        size: 20,
                                      ),
                                    )
                                  : Container(),
                              Icon(Iconsax.arrow_down_1),
                            ],
                          )),
                    )
                  : Expanded(flex: 40, child: Container())
            ],
          ),
        )
      ],
    );
  }
}
