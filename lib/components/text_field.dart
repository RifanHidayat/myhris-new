import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:siscom_operasional/components/text.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class TextFieldApp {
  static Widget groupColumn(
      {hintText,
      controller,
      keyBoardType,
      bgColor,
      width,
      title,
      validator,
      onChange,
      format,
      enabled,
      icon,
      isPassword,subtitle}) {
    return Container(
      width: width ?? MediaQuery.of(Get.context!).size.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp.label(
              text: title,
              weigh: FontWeight.w600,
              size: 14.0,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              enabled: enabled ?? true,
              inputFormatters: format,
              keyboardType: keyBoardType ?? TextInputType.text,
              controller: controller,
              decoration: icon == null || icon == ""
                  ? InputDecoration(
                      hintText: hintText ?? "",
                      hintStyle: TextStyle(color: Constanst.Secondary),
                      contentPadding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15, bottom: 0),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      fillColor: bgColor ?? Colors.transparent,
                      filled: true,
                    )
                  : InputDecoration(
                      // suffixIcon: Suc,
                      prefixIcon: Icon(
                        icon,
                        color: Constanst.border,
                      ),
                      hintText: hintText ?? "",
                      hintStyle: TextStyle(color: Constanst.Secondary),
                      contentPadding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15, bottom: 0),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      fillColor: bgColor ?? Colors.transparent,
                      filled: true,
                    ),
              style: TextStyle(
                color:Constanst.colorBlack,
              ),
              validator: validator,
              onChanged: onChange,
            ),
            SizedBox(height: 5,),
            TextLabell(text: subtitle ?? "",size: 12,color:Constanst.border,)
          ],
        ),
      ),
    );
  }
  static Widget groupColumnSelected(
      {hintText,
      controller,
      keyBoardType,
      bgColor,
      width,
      title,
      validator,
      onChange,
      format,
      enabled,
      icon,
      onTap,
      isPassword}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(Get.context!).size.width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextApp.label(
                text: title,
                weigh: FontWeight.w600,
                size: 14.0,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: enabled ?? true,
                inputFormatters: format,
                keyboardType: keyBoardType ?? TextInputType.text,
                controller: controller,
                decoration: icon == null || icon == ""
                    ? InputDecoration(
                        hintText: hintText ?? "",
                        hintStyle: TextStyle(color: Constanst.Secondary),
                        contentPadding: const EdgeInsets.only(
                            left: 15, top: 8, right: 15, bottom: 0),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                            color: bgColor ?? Constanst.border,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: bgColor ?? Constanst.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: bgColor ?? Constanst.border,
                          ),
                        ),
                        fillColor: bgColor ?? Colors.transparent,
                        filled: true,
                      )
                    : InputDecoration(
                        // suffixIcon: Suc,
                        suffixIcon: Icon(
                          icon,
                          color: Constanst.border,
                        ),
                        hintText: hintText ?? "",
                        hintStyle: TextStyle(color: Constanst.Secondary),
                        contentPadding: const EdgeInsets.only(
                            left: 15, top: 8, right: 15, bottom: 0),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                            color: bgColor ?? Constanst.border,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: bgColor ?? Constanst.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: bgColor ?? Constanst.border,
                          ),
                        ),
                        fillColor: bgColor ?? Colors.transparent,
                        filled: true,
                      ),
                style: TextStyle(
                  color:Constanst.colorBlack,
                ),
                validator: validator,
                onChanged: onChange,
              ),
            ],
          ),
        ),
      ),
    );
  }
  static Widget groupColumnPassword(
      {hintText,
      controller,
      keyBoardType,
      bgColor,
      width,
      title,
      validator,
      onChange,
      format,
      enabled,
      icon,
      isPassword,
      onTap,visble}) {
    return Container(
      width: width ?? MediaQuery.of(Get.context!).size.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp.label(
              text: title,
              weigh: FontWeight.w600,
              size: 14.0,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              enabled: enabled ?? true,
              inputFormatters: format,
              keyboardType: TextInputType.text,
              obscureText: visble??true,
              controller: controller,
              decoration: icon == null || icon == ""
                  ? InputDecoration(
                    
                       suffixIcon: InkWell(
                          onTap: onTap,
                          child: visble==true? Icon(
                            Iconsax.eye_slash,
                            color: Constanst.Secondary,
                          ):Icon(
                            Iconsax.eye,
                            color: Constanst.Secondary,
                          )),
                      hintText: hintText ?? "",
                      hintStyle: TextStyle(color: Constanst.Secondary),
                      contentPadding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15, bottom: 0),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                          width: 2.0,
                        ),
                        
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      fillColor: bgColor ?? Colors.transparent,
                      filled: true,
                      
                    )
                  : InputDecoration(
                    suffixIcon: InkWell(
                          onTap: onTap,
                          child: visble==true? Icon(
                            Iconsax.eye_slash,
                            color: Constanst.Secondary,
                          ):Icon(
                            Iconsax.eye,
                            color: Constanst.Secondary,
                          )),
                      // suffixIcon: Suc,
                      prefixIcon: Icon(
                        icon,
                        color:Constanst.border,
                      ),
                      hintText: hintText ?? "",
                      hintStyle: TextStyle(color: Constanst.Secondary),
                      contentPadding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15, bottom: 0),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      fillColor: bgColor ?? Colors.transparent,
                      filled: true,
                    ),
              style: TextStyle(
                color:Constanst.colorBlack,
              ),
              validator: validator,
              onChanged: onChange,
            ),
          ],
        ),
      ),
    );
  }

   static Widget search(
      {hintText,
      controller,
      keyBoardType,
      bgColor,
      width,
      title,
      validator,
      onChange,
      format,
      enabled,
      onTap
     
     }) {
    return Container(
      width: width ?? MediaQuery.of(Get.context!).size.width,
      child: Row(
        children: [
          Expanded(
            flex: 70,
            child: TextFormField(
              enabled: enabled ?? true,
              inputFormatters: format,
              keyboardType: keyBoardType ?? TextInputType.text,
              controller: controller,
              decoration:  InputDecoration(
                      hintText: hintText ?? "",
                      hintStyle: TextStyle(color: Constanst.Secondary),
                      contentPadding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15, bottom: 0),
                      border: OutlineInputBorder(
                         borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)
                        ),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)
                        ),
                        borderSide: BorderSide(
                          color: bgColor ??Constanst.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)
                        ),
                        borderSide: BorderSide(
                          color: bgColor ?? Constanst.border,
                        ),
                      ),
                      fillColor: bgColor ?? Colors.transparent,
                      filled: true,
                    ),
              style: TextStyle(
                color: Constanst.colorBlack,
              ),
              validator: validator,
              onChanged: onChange,
            ),
          ),
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: onTap,
              child: Container(
                      
              
              decoration: BoxDecoration(
                      
                borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight:Radius.circular(8)),
                border: Border.all(width: 1,color: Constanst.border,)
              ),
              padding: EdgeInsets.only(top: 11,bottom: 11,left: 9,right: 9),
              child:Icon(Iconsax.search_normal) ,
                      ),
            )),
    
        ],
      ),
    );
  }

}
